import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meals_management_with_firebase/models/user_model.dart';
import 'package:meals_management_with_firebase/providers/admin_employees_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_home_provider.dart';
import 'package:meals_management_with_firebase/providers/events_provider.dart';
import 'package:meals_management_with_firebase/providers/user_data_provider.dart';
import 'package:meals_management_with_firebase/repositories/firebase_auth_repo.dart';
import 'package:meals_management_with_firebase/utils/constants.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_button.dart';
import 'package:meals_management_with_firebase/views/custom_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';



class EmployeeHomeView extends StatefulWidget {
  const EmployeeHomeView({super.key});

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView> {
  DateTime now = DateTime.now();

  TextEditingController notOptController = TextEditingController();

  DateRangePickerController datesController = DateRangePickerController();

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    initData();
    initiate();
  }

  Future<void> initData() async {
    try {
      await Provider.of<UserDataProvider>(context, listen: false).setUser();
      await Provider.of<EventsProvider>(context, listen: false)
          .getOptedFromDB();
      await Provider.of<EventsProvider>(context, listen: false)
          .getNotOptedFromDB();
      await Provider.of<EventsProvider>(context, listen: false)
          .getNotOptedWithReasonsFromDB();
      await Provider.of<EmployeeHomeProvider>(context, listen: false)
          .setFloorDetails();
      await Provider.of<AdminEmployeesProvider>(context, listen: false).setEmpData();
    } finally {
      setState(() {
        Constants.homeIsLoading = false;
      });
    }
  }

  Future<void> initiate() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {

    UserModel? user =
         Provider.of<UserDataProvider>(context, listen: false).getUser;
  
    final size = MediaQuery.of(context).size;
    
    List<Map<String, Map<String, dynamic>>> floorDetails =
        Provider.of<EmployeeHomeProvider>(context, listen: false)
            .getFloorDetails;
    Map<String, dynamic> timings = Constants.homeIsLoading
        ? {}
        : floorDetails.map((e) => e[user!.floor]).nonNulls.toList()[0]; 

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Constants.homeIsLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        height: size.height * 0.20,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(100, 179, 110, 234),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            )),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Consumer<EmployeeHomeProvider>(
                              builder: (context, provider, child) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 25, top: 15),
                                  child: Text(
                                    'Hi,\n${user!.userName}',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            ),
                            const Expanded(child: SizedBox()),
                            Consumer<EmployeeHomeProvider>(
                              builder: (context, provider, child) {
                                return user!.isAdmin
                                    ? Switch(
                                        value: false,
                                        onChanged: (value) {
                                          Navigator.pushReplacementNamed(
                                              context, '/admin_homepage');
                                        },
                                        activeColor: const Color.fromARGB(
                                            255, 181, 129, 248),
                                      )
                                    : const SizedBox();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                        value: 'Sign Out',
                                        height: 10,
                                        onTap: () {
                                          FirebaseAuthRepo()
                                              .signOutNow()
                                              .then((value) {
                                            sharedPreferences.setString(
                                                'islogged', 'false');
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                "/login_page",
                                                (route) => false);
                                          });
                                          // ignore: avoid_print
                                          print('navigated to login page');
                                        },
                                        child: const Text('Sign Out'))
                                  ];
                                },
                                child:
                                    const Icon(Icons.power_settings_new_sharp),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SizedBox(
                        width: size.width * 0.95,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          elevation: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 18.0, top: 4),
                                child: Text('Lunch Calendar'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 18),
                                child: Text(
                                  '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                              const Divider(),
                              Consumer<EmployeeHomeProvider>(
                                builder: (context, provider, child) {
                                  return SfDateRangePicker(
                                    controller: datesController,
                                    selectionColor: Colors.deepPurple.shade200,
                                    selectionShape: DateRangePickerSelectionShape.circle,
                                    cellBuilder: (BuildContext context, DateRangePickerCellDetails details) {
                                        bool isOpted = Provider.of<EventsProvider>(context, listen: false).getOpted.contains(details.date); 
                                        bool isNotOpted = Provider.of<EventsProvider>(context, listen: false).getNotOpted.contains(details.date);
                                        Color circleColor = isOpted ? Colors.green.shade200 :
                                                                  isNotOpted ? Colors.orange.shade200 :
                                                                        (details.date.weekday == DateTime.sunday || details.date.weekday == DateTime.saturday) ? Colors.blueGrey.shade200 : Colors.white30;
                                        return Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Container(
                                              width: details.bounds.width/2,
                                              height: details.bounds.width/2,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: circleColor,
                                              ),
                                              child: Center(child: Text(details.date.day.toString())),
                                            ),
                                        );
                                      },
                                    showActionButtons: true,
                                    allowViewNavigation: true,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    showNavigationArrow: true,
                                    onSubmit: (date) {
                                      if (date == null ||
                                          date.toString().substring(0, 10) !=
                                              now.toString().substring(0, 10)) {
                                        CustomSnackBar.showSnackBar(context, 'please select todays date');
                                      } 
                                      else if([DateTime.sunday, DateTime.saturday].contains(DateTime.parse(date.toString()).weekday)){
                                        CustomSnackBar.showSnackBar(context, 'cannot opt on weekoffs');
                                      }
                                      else {
                                        notOptController.clear();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(content:
                                                Consumer<EmployeeHomeProvider>(
                                              builder: (context, dialogProvider, child) {
                                                return SizedBox(
                                                  width: size.width * 0.6,
                                                  height:
                                                      dialogProvider.getRadioValue ==
                                                              2
                                                          ? size.height * 0.365
                                                          : size.height * 0.22,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      _radioButtons(
                                                          provider: dialogProvider,
                                                          text: 'Opt and Sign',
                                                          value: 1),
                                                      _radioButtons(
                                                          provider: dialogProvider,
                                                          text: 'Not opt',
                                                          value: 2),
                                                      if (dialogProvider
                                                              .getRadioValue ==
                                                          2)
                                                        TextFormField(
                                                          controller:
                                                              notOptController,
                                                          decoration: InputDecoration(
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              hintText:
                                                                  'reason for not opting...',
                                                              hintStyle: const TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                              errorText: dialogProvider
                                                                      .getReasonEmpty
                                                                  ? 'reason cannot be empty'
                                                                  : null),
                                                          maxLines: 2,
                                                          maxLength: 30,
                                                          onChanged: (value) {
                                                            if (value.isEmpty) {
                                                              dialogProvider
                                                                  .setReasonEmpty(
                                                                      true);
                                                            } else {
                                                              dialogProvider
                                                                  .setReasonEmpty(
                                                                      false);
                                                            }
                                                          },
                                                        ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          CustomButton(
                                                            onPressed: () {
                                                              datesController.selectedDate = null;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            color:
                                                                const MaterialStatePropertyAll(
                                                                    Colors
                                                                        .white),
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          CustomButton(
                                                            onPressed: () {
                                                              if (dialogProvider
                                                                      .getRadioValue ==
                                                                  1) {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/sign',
                                                                    arguments: {
                                                                      'date':
                                                                          date
                                                                    });
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {
                                                                  Provider.of<EventsProvider>(context, listen: false).pushDate(
                                                                        date: date as DateTime,
                                                                        radioValue:
                                                                            dialogProvider
                                                                                .getRadioValue,
                                                                        reason:
                                                                            notOptController.text);
                                                                  initData();
                                                                  datesController.selectedDate = null;
                                                                });
                                                              }
                                                            },
                                                            color: MaterialStatePropertyAll(
                                                                Colors
                                                                    .deepPurpleAccent
                                                                    .shade200),
                                                            child: const Text(
                                                              'Proceed',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ));
                                          },
                                        );
                                      }
                                    },
                                  onCancel: () {
                                      datesController.selectedDate = null;
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _options(
                                color: Colors.green.shade200,
                                text: const Text(
                                  'Signed',
                                  style: TextStyle(fontSize: 10),
                                )),
                            _options(
                                color: Colors.grey.shade300,
                                text: const Text(
                                  'Not Signed',
                                  style: TextStyle(fontSize: 10),
                                )),
                            _options(
                                color: Colors.orange.shade200,
                                text: const Text(
                                  'Not Opted',
                                  style: TextStyle(fontSize: 10),
                                )),
                            _options(
                                color: Colors.red.shade100,
                                text: const Text(
                                  'Holiday',
                                  style: TextStyle(fontSize: 10),
                                )),
                          ],
                        ),
                      ),
                      Image.asset('assets/images/food_png.png'),
                    ],
                  ),
                  Positioned(
                    top: -480,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.07,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: size.height * 0.12,
                            child: Card(
                              color: const Color.fromARGB(255, 234, 221, 255),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              elevation: 10,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time_sharp),
                                      SizedBox(width: 5),
                                      Text(
                                        'Lunch Timings',
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Start time',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            'End time',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(':'),
                                          Text(':'),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            timings['start_time'],
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            timings['end_time'],
                                            style:
                                                const TextStyle(fontSize: 12),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: size.height * 0.12,
                            child: Card(
                              color: const Color.fromARGB(255, 234, 221, 255),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              elevation: 10,
                              child: TextButton(
                                child: const Text(
                                  'Update upcoming\nlunch status',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/update_upcoming_status');
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.07,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _options({required color, required text}) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
        ),
        text,
      ],
    );
  }

  Widget _radioButtons({required provider, required text, required value}) {
    return RadioListTile<int>(
        title: Text(text),
        value: value,
        groupValue: provider.getRadioValue,
        onChanged: (value) {
          provider.setRadioValue(value);
        });
  }

  
}

