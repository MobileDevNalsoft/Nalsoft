import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/firebase_auth_repo.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_beep/flutter_beep.dart';

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

  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String? qrResult;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      await Provider.of<UserDataProvider>(context, listen: false)
          .getUserFromDB();
      await Provider.of<HomeStatusProvider>(context, listen: false)
          .setFloorDetails();
      await Provider.of<UserDataProvider>(context, listen: false).setHolidays();
      Provider.of<UserDataProvider>(context, listen: false)
          .setNotOptedDatesWithReason();
    } finally {
      setState(() {
        Constants.empHomeIsLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Map<String, Map<String, dynamic>>> floorDetails =
        Provider.of<HomeStatusProvider>(context, listen: false).getFloorDetails;
    Map<String, dynamic> timings = Constants.empHomeIsLoading
        ? {}
        : floorDetails
            .map((e) => e[
                Provider.of<UserDataProvider>(context, listen: false).getFloor])
            .nonNulls
            .toList()[0];

    return SafeArea(
      child: Provider.of<UserDataProvider>(context, listen: false)
                  .getUsername ==
              'vendor'
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // PopupMenuButton(
                    //   itemBuilder: (BuildContext context) {
                    //     return [
                    //       PopupMenuItem(
                    //           value: 'Sign Out',
                    //           height: 10,
                    //           onTap: () {
                    //             FirebaseAuthRepo().signOutNow().then((value) {
                    //               sharedPreferences.setString(
                    //                   'islogged', 'false');
                    //               Navigator.pushNamedAndRemoveUntil(
                    //                   context,
                    //                   RouteManagement.loginPage,
                    //                   (route) => false);
                    //             });
                    //             // ignore: avoid_print
                    //             print('navigated to login page');
                    //           },
                    //           child: const Text('Sign Out'))
                    //     ];
                    //   },
                    //   child: const Icon(Icons.power_settings_new_sharp),
                    // ),
                    // Text(
                    //   'Scan QR Code',
                    //   style: TextStyle(fontSize: 25),
                    // ),
                    Expanded(
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: (controller) {
                          controller.scannedDataStream.listen((data) {
                            var empData = jsonDecode(data.toString());
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
                    // Icon(
                    //   Icons.qr_code_scanner_rounded,
                    //   size: 300,
                    // ),
                    // CustomButton(
                    //   child: Text('Scan'),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              body: Constants.empHomeIsLoading
                  ? const Center(
                      child: SpinKitCircle(
                          color: Color.fromARGB(255, 179, 157, 219),
                          size: 50.0),
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, top: 15),
                                    child: Text(
                                      'Hi,\n${Provider.of<UserDataProvider>(context, listen: false).getUsername}',
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Provider.of<UserDataProvider>(context,
                                              listen: false)
                                          .getIsAdmin!
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
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          RouteManagement
                                                              .loginPage,
                                                          (route) => false);
                                                });
                                                // ignore: avoid_print
                                                print(
                                                    'navigated to login page');
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
                                      padding:
                                          EdgeInsets.only(left: 18.0, top: 4),
                                      child: Text('Lunch Calendar'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 18),
                                      child: Text(
                                        '${DateFormat('EEEE').format(now).substring(0, 3)}, ${DateFormat('MMMM').format(now).substring(0, 3)} ${now.day}',
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                                    const Divider(),
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('employees')
                                          .doc(_auth.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return SfDateRangePicker(
                                          controller: datesController,
                                          minDate: DateTime(
                                              now.year, 1, 1, 0, 0, 0, 0, 0),
                                          maxDate: DateTime(now.year, 12, 31,
                                              23, 59, 0, 0, 0),
                                          selectionColor:
                                              Colors.deepPurple.shade100,
                                          selectionShape:
                                              DateRangePickerSelectionShape
                                                  .circle,
                                          // selectableDayPredicate: (date) {
                                          //   return date
                                          //               .toString()
                                          //               .substring(0, 10) ==
                                          //           now
                                          //               .toString()
                                          //               .substring(0, 10) &&
                                          //       ![
                                          //         DateTime.saturday,
                                          //         DateTime.sunday
                                          //       ].contains(date.weekday) &&
                                          //       !provider.getHolidays
                                          //           .contains(
                                          //               date.toString());
                                          // },
                                          cellBuilder: (BuildContext context,
                                              DateRangePickerCellDetails
                                                  details) {
                                            Color circleColor = snapshot
                                                    .data!['opted']
                                                    .contains(details.date
                                                        .toString()
                                                        .substring(0, 10))
                                                ? Colors.green.shade200
                                                : snapshot.data!['notOpted'].keys
                                                        .contains(details.date
                                                            .toString()
                                                            .substring(0, 10))
                                                    ? Colors.orange.shade200
                                                    : Provider.of<UserDataProvider>(context, listen: false)
                                                            .getHolidays
                                                            .contains(details
                                                                .date
                                                                .toString()
                                                                .substring(0, 10))
                                                        ? Colors.red.shade100
                                                        : (details.date.weekday == DateTime.sunday || details.date.weekday == DateTime.saturday)
                                                            ? Colors.blueGrey.shade200
                                                            : ((details.date.day == now.day && details.date.month <= now.month && now.hour >= 15 && !Provider.of<UserDataProvider>(context, listen: false).getOpted.contains(details.date.toString().substring(0, 10)) && !Provider.of<UserDataProvider>(context, listen: false).getNotOptedWithReasons.keys.contains(details.date.toString().substring(0, 10))) || ((details.date.day < now.day && details.date.month <= now.month) && !Provider.of<UserDataProvider>(context, listen: false).getOpted.contains(details.date.toString().substring(0, 10)) && !Provider.of<UserDataProvider>(context, listen: false).getNotOptedWithReasons.keys.contains(details.date.toString().substring(0, 10))))
                                                                ? Colors.grey.shade300
                                                                : Colors.white30;
                                            return Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                width: details.bounds.width / 2,
                                                height:
                                                    details.bounds.width / 2,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: circleColor,
                                                ),
                                                child: Center(
                                                    child: Text(details.date.day
                                                        .toString())),
                                              ),
                                            );
                                          },
                                          showActionButtons: true,
                                          allowViewNavigation: true,
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .single,
                                          showNavigationArrow: true,
                                          onSubmit: (date) {
                                            if (date == null) {
                                              CustomSnackBar.showSnackBar(
                                                  context,
                                                  'Please select today'
                                                  's date',
                                                  Colors.red);
                                            } else if (snapshot.data!['opted']
                                                .contains(date
                                                    .toString()
                                                    .toString())) {
                                              Navigator.pushNamed(context,
                                                  RouteManagement.previewPage);
                                            } else if (
                                                // (now.hour > 14 ||
                                                //   (now.hour == 14 &&
                                                //       now.minute > 30))
                                                false) {
                                              CustomSnackBar.showSnackBar(
                                                  context,
                                                  "You cannot update status after 2.30pm",
                                                  Colors.red);
                                            } else if (
                                                // (now.hour < 12 ||
                                                //   (now.hour == 12 &&
                                                //       now.minute < 30))
                                                false) {
                                              CustomSnackBar.showSnackBar(
                                                  context,
                                                  "Wait till 12.30pm to Sign",
                                                  Colors.red);
                                            } else {
                                              Navigator.pushNamed(context,
                                                  RouteManagement.previewPage);
                                            }
                                          },
                                          onCancel: () {
                                            datesController.selectedDate = null;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _options(
                                      color: Colors.green.shade200,
                                      text: const Text(
                                        'Opted',
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
                                  _options(
                                      color: Colors.grey.shade300,
                                      text: const Text(
                                        'No Status',
                                        style: TextStyle(fontSize: 10),
                                      )),
                                ],
                              ),
                            ),
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
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: size.height * 0.12,
                                  child: Card(
                                    color: const Color.fromARGB(
                                        255, 234, 221, 255),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    elevation: 10,
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
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  'End time',
                                                  style:
                                                      TextStyle(fontSize: 12),
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
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  timings['end_time'],
                                                  style: const TextStyle(
                                                      fontSize: 12),
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
                                    color: const Color.fromARGB(
                                        255, 234, 221, 255),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
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
                                            context,
                                            RouteManagement
                                                .updateUpcomingStatus);
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

  Future<void> scanQR() async {
    try {
      if (!mounted) return;
      // FlutterBarcodeScanner.getBarcodeStreamReceiver(
      //         "#ff6666", "Cancel", false, ScanMode.QR)!
      //     .listen((barcode) async {
      //   var qrData = jsonDecode(barcode.toString());
      //   if (qrData['date'] == now.toString().substring(0, 10)) {
      //     bool isAlreadyScanned =
      //         await Provider.of<UserDataProvider>(context, listen: false)
      //             .pushOptedDate(uid: qrData['uid']);
      //     if (isAlreadyScanned) {
      //       CustomSnackBar.showSnackBar(
      //           context, 'QR already scanned', Colors.red);
      //       return;
      //     } else {
      //       FlutterBeep.beep();
      //     }
      //   } else {
      //     CustomSnackBar.showSnackBar(context, 'Invalid QR', Colors.red);
      //   }
      // });
    } catch (e) {
      print(e);
    }
  }
}
