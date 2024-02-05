import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// ignore: depend_on_referenced_packages
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/mixin/network_handler.dart';
import 'package:meals_management/models/user_events_model.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/user_repo.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_calendar_card.dart';
import 'package:meals_management/views/custom_widgets/custom_legend.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EmployeeHomeView extends StatefulWidget  {
  const EmployeeHomeView({super.key});

  @override
  State<EmployeeHomeView> createState() => _EmployeeHomeViewState();
}

class _EmployeeHomeViewState extends State<EmployeeHomeView>  with ConnectivityMixin{
  DateTime now = DateTime.now();

  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  // used to modify QR view
  QRViewController? qrController;

  late StreamSubscription subscription;

  // to identify QR widgt in widget tree
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  UserRepo userRepo = UserRepo();

  final sharedPreferences = sl.get<SharedPreferences>();

  bool _showQR = false;
  bool _hasShownSnackbar = false;
  bool _isIncremented = false;
  bool _isLoading = true;
  

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    print("did init");
    try {
      await Provider.of<UserDataProvider>(context, listen: false)
          .getUserinfo('');
      await Provider.of<UserDataProvider>(context, listen: false)
          .getUserEventsData();
      await Provider.of<UserDataProvider>(context, listen: false).getHolidays();
    } finally {
      setState(() {
        if (Provider.of<UserDataProvider>(context, listen: false)
                .getUserData
                .data!
                .userType ==
            'V') {
          DateTime lastResetDate = sharedPreferences
                  .containsKey('lastResetDate')
              ? DateTime.parse(sharedPreferences.getString('lastResetDate')!)
              : DateTime.now();

          if (!sharedPreferences.containsKey('lastResetDate')) {
            sharedPreferences.setString('lastResetDate', now.toString());
            sharedPreferences.setInt('employeeCount', 0);
            Provider.of<HomeStatusProvider>(context, listen: false)
                .setEmployeeCount(
                    sharedPreferences.getInt('employeeCount') ?? 0);
          } else if (now.day != lastResetDate.day) {
            sharedPreferences.setString('lastResetDate', now.toString());
            sharedPreferences.setInt('employeeCount', 0);
            Provider.of<HomeStatusProvider>(context, listen: false)
                .setEmployeeCount(
                    sharedPreferences.getInt('employeeCount') ?? 0);
          } else {
            Provider.of<HomeStatusProvider>(context, listen: false)
                .setEmployeeCount(
                    sharedPreferences.getInt('employeeCount') ?? 0);
          }
        }
        _isLoading = false;
      });
    }
  }
@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if(isConnected()){
      print("did changes connected");
      initData();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    if(!isConnected()){
      Navigator.pushNamed(context, '/network_error');
    }
    final size = MediaQuery.of(context).size;
    
   
    Map<String, dynamic> timings =
        _isLoading ? {} : {"start_time": "12:30 pm", "end_time": "2:30 pm"};

    return AspectRatio(
      aspectRatio: size.height/size.width,
      child: SafeArea(
          child: Scaffold(
        body: _isLoading
            ? const Center(
                child: SpinKitCircle(
                    color: Color.fromARGB(255, 179, 157, 219), size: 50.0),
              )
            : Provider.of<UserDataProvider>(context, listen: false)
                        .getUserData
                        .data!
                        .userType ==
                    'V'
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: SizedBox(),
                            ),
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                      value: 'Sign Out',
                                      height: 10,
                                      onTap: () {
                                        sharedPreferences.setString(
                                            AppConstants.TOKEN, '');
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            RouteManagement.loginPage,
                                            (route) => false);
                                      },
                                      child: const Text('Sign Out'))
                                ];
                              },
                              child: const Icon(Icons.power_settings_new_sharp),
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.08,
                        ),
                        const Text(
                          'Scan QR Code',
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Consumer<HomeStatusProvider>(
                          builder: (context, provider, child) {
                            return Text(
                                'Employee Count : ${sharedPreferences.getInt('employeeCount')}');
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        if (_showQR)
                          SizedBox(
                            height: size.height * 0.40,
                            width: size.width * 0.9,
                            child: QRView(
                              key: qrKey,
                              onQRViewCreated: (controller) {
                                qrController = controller;
                                controller.scannedDataStream
                                    .listen((data) async {


                                  var qrData = jsonDecode(data.code!);
                                  print(" Qr Data scanned${qrData.toString()}");
                                  if (qrData['date'] ==
                                      now.toString().substring(0, 10)) {
                                    Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .updateUserEvents([
                                      Dates(
                                              date: qrData['date']!,
                                              info: now.millisecondsSinceEpoch
                                                  .toString())
                                          .toJson()
                                    ], true).then((value) {
                                         if (Provider.of<UserDataProvider>(context,
                                            listen: false).getIsAlreadyScanned) {
                                        if (!_hasShownSnackbar) {
                                          setState(() {
                                            _showQR = false;
                                            _hasShownSnackbar = true;
                                            CustomSnackBar.showSnackBar(context,
                                                'QR already scanned', Colors.red);
                                          });

                                         Provider.of<UserDataProvider>(context,
                                            listen: false) .setScanned(false);
                                          controller.pauseCamera();
                                        }
                                      } else {
                                        FlutterBeep.beep();
                                        if (!_isIncremented) {

                                          // ignore: use_build_context_synchronously
                                          Provider.of<HomeStatusProvider>(context,
                                                  listen: false)
                                              .incrEmpCount();
                                          sharedPreferences.setInt(
                                              'employeeCount',
                                              // ignore: use_build_context_synchronously
                                              Provider.of<HomeStatusProvider>(
                                                      context,
                                                      listen: false)
                                                  .getEmployeeCount!);
                                          _isIncremented = true;
                                        }
                                        controller.pauseCamera();
                                        Future.delayed(const Duration(seconds: 2),
                                            () {
                                          controller.resumeCamera();
                                          _isIncremented = false;
                                        });
                                      }
                                    });
                                     
                                    } else {
                                      if (!_hasShownSnackbar) {
                                        setState(() {
                                          _showQR = false;
                                          _hasShownSnackbar = true;
                                          CustomSnackBar.showSnackBar(
                                              context, 'Invalid QR', Colors.red);
                                        });
                                        controller.pauseCamera();
                                      }
                                  }
                                });
                              },
                              overlay: QrScannerOverlayShape(
                                  borderColor: Colors.red,
                                  borderRadius: 10,
                                  borderLength: 30,
                                  borderWidth: 10,
                                  cutOutSize: 300),
                            ),
                          ),
                        if (_showQR)
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                        if (!_showQR)
                          const Icon(
                            Icons.qr_code_scanner_rounded,
                            size: 340,
                          ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_showQR)
                              CustomButton(
                                onPressed: () {
                                  setState(() {
                                    _showQR = true;
                                    _hasShownSnackbar = false;
                                  });
                                },
                                color: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                                child: const Text(
                                  'Scan',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            if (_showQR)
                              CustomButton(
                                onPressed: () {
                                  setState(() {
                                    qrController!.flipCamera();
                                  });
                                },
                                color: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                                child: const Icon(Icons.flip_camera_android,
                                    color: Colors.black),
                              ),
                            if (_showQR)
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                            if (_showQR)
                              CustomButton(
                                onPressed: () {
                                  setState(() {
                                    _showQR = false;
                                    qrController!.pauseCamera();
                                  });
                                },
                                color: MaterialStatePropertyAll(
                                    Colors.grey.shade300),
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
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
                            child: Column(
                              children: [
                                SizedBox(height: size.height*0.015,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: size.width*0.05,),
                                    SizedBox(
                                      height: size.height*0.1,
                                      width: size.width*0.6,
                                      child: Text(
                                        'Hi,\n${Provider.of<UserDataProvider>(context, listen: false).getUserData.data!.empName}',
                                        style:  TextStyle(
                                            fontSize: size.width*0.057 ,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Provider.of<UserDataProvider>(context,
                                                    listen: false)
                                                .getUserData
                                                .data!
                                                .userType ==
                                            'E'
                                        ? Switch(
                                            value: false,
                                            onChanged: (value) {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  RouteManagement.adminHomePage);
                                            },
                                            activeColor: const Color.fromARGB(
                                                255, 181, 129, 248),
                                          )
                                        : const SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.only(right:10.0, top: 10, left: 10),
                                      child: PopupMenuButton(
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            PopupMenuItem(
                                                value: 'Sign Out',
                                                height: 10,
                                                onTap: () {
                                                  sharedPreferences.setString(
                                                      AppConstants.TOKEN, '');
                                                  Navigator.pushNamedAndRemoveUntil(
                                                      context,
                                                      RouteManagement.loginPage,
                                                      (route) => false);
                                                },
                                                child: const Text('Sign Out'))
                                          ];
                                        },
                                        child: const Icon(
                                            Icons.power_settings_new_sharp),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          CustomCalendarCard(
                            controller: datesController,
                            forAdmin: false,
                            selectionMode: DateRangePickerSelectionMode.single,
                            selectibleDayPredicate: (date) {
                              return date.toString().substring(0, 10) ==
                                      now.toString().substring(0, 10) &&
                                  ![DateTime.saturday, DateTime.sunday]
                                      .contains(date.weekday) &&
                                  !Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .holidays
                                      .contains(
                                          date.toString().substring(0, 10)) &&
                                  !Provider.of<UserDataProvider>(context,
                                          listen: false)
                                      .getNotOpted
                                      .map((e) => e.date)
                                      .toList()
                                      .contains(
                                          date.toString().substring(0, 10)) &&
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
                              } else if (
                                  // (now.hour > 14 ||
                                  //   (now.hour == 14 &&
                                  //       now.minute > 30))
                                  false) {
                                CustomSnackBar.showSnackBar(context,
                                    "QR is disabled after 2.30pm", Colors.red);
                              } else if (
                                  // (now.hour < 12 ||
                                  //   (now.hour == 12 &&
                                  //       now.minute < 30))
                                  false) {
                                CustomSnackBar.showSnackBar(context,
                                    "Wait till 12.30pm to get QR", Colors.red);
                              } else {
                                Navigator.pushNamed(
                                    context, RouteManagement.previewPage);
                              }
                            },
                            onCancel: () {
                              datesController.selectedDate = null;
                            },
                            confirmText: 'Ok',
                            cancelText: 'Cancel',
                          ),
                          const CustomLegend(),
                          Image.asset('assets/images/food.png'),
                        ],
                      ),
                      Positioned(
                        top: (size.height * 0.12),
                        // bottom: ,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.07,
                            ),
                            _overlayCard(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              '1:00pm',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              '2:00pm',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                size: size),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            _overlayCard(
                                child: TextButton(
                                  child: const Text(
                                    'Update upcoming\nlunch status',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context,
                                        RouteManagement.updateUpcomingStatus);
                                  },
                                ),
                                size: size),
                            SizedBox(
                              width: size.width * 0.07,
                            ),
                          ],
                        ),
                      ),
                      if(!isConnected())
                        SizedBox(
                          height: size.height*0.1,
                          child: Container(
                            color: Colors.red,
                          ),
                        )
                      
                    ],
                  ),
      )),
    );
  }

  Widget _overlayCard({required child, required size}) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: size.height * 0.12,
        child: Card(
          color: const Color.fromARGB(255, 234, 221, 255),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          elevation: 10,
          child: child,
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
