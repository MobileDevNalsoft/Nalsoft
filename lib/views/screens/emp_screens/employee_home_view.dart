import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/user_repo.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/custom_widgets/custom_calendar_card.dart';
import 'package:meals_management/views/custom_widgets/custom_legend.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:meals_management/views/screens/admin_screens/admin_home_view.dart';
import 'package:meals_management/views/screens/emp_screens/employee_preview_view.dart';
import 'package:meals_management/views/screens/emp_screens/employee_update_upcoming_status_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:custom_widgets/src.dart';

// ignore: must_be_immutable
class EmployeeHomeView extends StatefulWidget {
  late Function? initData;
  EmployeeHomeView({super.key, this.initData});

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView>
    with ConnectivityMixin {
  DateTime now = DateTime.now();

  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  UserRepo userRepo = UserRepo();

  final sharedPreferences = sl.get<SharedPreferences>();

  @override
  void dispose() {
    datesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: size.height * 0.13,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 179, 110, 234),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                          width: size.width * 0.5,
                          child: Text(
                            'Hi,\n${sharedPreferences.getString('employee_name') ?? ' '}',
                            style: TextStyle(
                                fontSize: size.width * 0.057,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteManagement.notifications);
                          },
                          icon: Icon(Icons.notifications),
                        ),
                        sharedPreferences.getString('user_type') == 'A'
                            ? Switch(
                                value: false,
                                onChanged: (value) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          AdminHomePage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                activeColor:
                                    const Color.fromARGB(255, 181, 129, 248),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, left: 10),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                    value: 'Log Out',
                                    height: 10,
                                    onTap: () {
                                      init();
                                      sharedPreferences.remove('employee_name');
                                      sharedPreferences.remove('employee_id');
                                      sharedPreferences
                                          .remove('employee_department');
                                      sharedPreferences.remove('user_type');
                                      Navigator.pushReplacementNamed(
                                        context,
                                        RouteManagement.loginPage,
                                      );
                                    },
                                    child: const Text('Log Out')),
                              ];
                            },
                            child: const Icon(Icons.power_settings_new_sharp),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Consumer<UserDataProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return SizedBox(
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
                            SizedBox(
                                height: size.height * 0.37,
                                child: CustomWidgets.CustomCircularLoader()),
                          ],
                        ),
                      ),
                    );
                  } else if (provider.eventsPresent) {
                    return CustomCalendarCard(
                      controller: datesController,
                      forAdmin: false,
                      isUDP: true,
                      selectionMode: DateRangePickerSelectionMode.single,
                      selectibleDayPredicate: (date) {
                        return date.toString().substring(0, 10) ==
                                now.toString().substring(0, 10) &&
                            ![DateTime.saturday, DateTime.sunday]
                                .contains(date.weekday) &&
                            !Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .holidays
                                .contains(date.toString().substring(0, 10)) &&
                            !Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .getNotOpted
                                .map((e) => e.date)
                                .toList()
                                .contains(date.toString().substring(0, 10)) &&
                            !Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .getOpted
                                .contains(date.toString().substring(0, 10));
                      },
                      onSubmit: (date) {
                        if (date == null) {
                          CustomSnackBar.showSnackBar(
                              context,
                              'Please select today'
                              's date',
                              Colors.red);
                        } else if ((now.hour >= 15)) {
                          CustomSnackBar.showSnackBar(
                              context, "QR is disabled after 3pm", Colors.red);
                        } else if ((now.hour < 12 ||
                            (now.hour == 12 && now.minute < 30))) {
                          CustomSnackBar.showSnackBar(context,
                              "Wait till 12.30pm to get QR", Colors.red);
                        } else {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      Preview(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      },
                      onCancel: () {
                        datesController.selectedDate = null;
                      },
                      confirmText: 'Ok',
                      cancelText: 'Cancel',
                    );
                  } else {
                    return SizedBox(
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
                            SizedBox(
                              height: size.height * 0.37,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .setConnected(isConnected());
                                    if (!Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .getConnected) {
                                      CustomSnackBar.showSnackBar(context,
                                          'No Internet Connection', Colors.red);
                                    } else {
                                      setState(() {
                                        Provider.of<UserDataProvider>(context,
                                                listen: false)
                                            .setConnected(isConnected());
                                        widget.initData!;
                                        Provider.of<UserDataProvider>(context,
                                                listen: false)
                                            .isLoading = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              const CustomLegend(),
              SizedBox(
                height: size.height * 0.06,
                width: size.width * 0.73,
                child: Card(
                  color: Color.fromRGBO(241, 232, 255, 1),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  UpdateLunchStatus(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        const Text(
                          'Update upcoming lunch status',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(Icons.keyboard_arrow_right_rounded)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Image.asset('assets/images/food.png'),
            ],
          ),
        ),
      ),
    );
  }
}

/*
from company's employee table we required fields like
1. Employee name,
2. Employee id,
3. User Type (E -> Employee, A -> Admin, V -> Vendor),
(we only get data from this table when user enters into app)

fields for events table ({mail id, date} can be a composite primary key)
1. Employee mail id
2. Date
3. Status => opted or not opted, no status if user dont eat and not updated date in not opted list
4. Info => scan time for scanned , reason for not opted, empty for not status
(we get and post the data when user's QR is scanned or when he updates single or multiple dates as not opted in update upcoming status)

holidays table
1. date 
(we only get data from this table when user enters into this table)
*/
