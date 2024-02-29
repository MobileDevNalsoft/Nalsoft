import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/models/user_events_model.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/custom_widgets/custom_button.dart';
import 'package:meals_management/views/custom_widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorHomeView extends StatefulWidget {
  @override
  _VendorHomeView createState() => _VendorHomeView();
}

class _VendorHomeView extends State<VendorHomeView> with ConnectivityMixin {
  bool _showQR = false;
  bool _hasShownSnackbar = false;
  bool _isIncremented = false;
  bool _isScanned = false;
  final sharedPreferences = sl.get<SharedPreferences>();

  var now = DateTime.now();

  // to identify QR widgt in widget tree
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // used to modify QR view
  QRViewController? qrController;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: AspectRatio(
        aspectRatio: size.height/size.width,
        child: Scaffold(
          body: Center(
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
                              value: 'Log Out',
                              height: 10,
                              onTap: () {
                                    init();
                                            sharedPreferences
                                                .remove('employee_name');
                                                sharedPreferences
                                                .remove('employee_id');
                                                 sharedPreferences.remove('employee_department');
                                            sharedPreferences.remove('user_type');
                                            Navigator.pushReplacementNamed(
                                              context,
                                              RouteManagement.loginPage,
                                            );
                              },
                              child: const Text('Log Out'))
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
        
                        controller.scannedDataStream.listen((data) async {
                          _isScanned = true;
                          if (_isScanned) controller.pauseCamera();
                          Future.delayed(
                            Duration(milliseconds: 500),
                            () {
                              controller.resumeCamera();
                              _isScanned = false;
                            },
                          );
                          var qrData = jsonDecode(data.code!);
                          Provider.of<UserDataProvider>(context, listen: false)
                              .setConnected(isConnected());
                          if (Provider.of<UserDataProvider>(context, listen: false)
                              .getConnected) {
                            print(" Qr Data scanned${qrData.toString()}");
                            if (qrData['date'] == now.toString().substring(0, 10)) {
                              Provider.of<UserDataProvider>(context, listen: false)
                                  .updateUserEvents([
                                Dates(
                                        date: qrData['date']!,
                                        info: now.millisecondsSinceEpoch.toString())
                                    .toJson()
                              ], true,qrData["uid"]).then((value) {
                                if (Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .getIsAlreadyScanned) {
                                  if (!_hasShownSnackbar) {
                                    setState(() {
                                      _showQR = false;
                                      _hasShownSnackbar = true;
                                      CustomSnackBar.showSnackBar(context,
                                          'QR already scanned', Colors.red);
                                    });
        
                                    Provider.of<UserDataProvider>(context,
                                            listen: false)
                                        .setScanned(false);
                                    controller.pauseCamera();
                                  }
                                } else {
                                  FlutterBeep.beep();
                                  if (!_isIncremented) {
                                    Provider.of<HomeStatusProvider>(context,
                                            listen: false)
                                        .incrEmpCount();
                                    sharedPreferences.setInt(
                                        'employeeCount',
                                        Provider.of<HomeStatusProvider>(context,
                                                listen: false)
                                            .getEmployeeCount!);
                                    _isIncremented = true;
                                  }
                                  controller.pauseCamera();
        
                                  print("camera paused");
                                  Future.delayed(const Duration(seconds: 2), () {
                                    print("in delay");
                                    controller.resumeCamera();
                                    _isIncremented = false;
                                  });
                                  print("after delay");
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
                          } else {
                            CustomSnackBar.showSnackBar(
                                context, 'No Internet', Colors.red);
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
                      CustomElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showQR = true;
                            _hasShownSnackbar = false;
                          });
                        },
                        color: MaterialStatePropertyAll(Colors.grey.shade300),
                        child: const Text(
                          'Scan',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    if (_showQR)
                      CustomElevatedButton(
                        onPressed: () {
                          setState(() {
                            qrController!.flipCamera();
                          });
                        },
                        color: MaterialStatePropertyAll(Colors.grey.shade300),
                        child: const Icon(Icons.flip_camera_android,
                            color: Colors.black),
                      ),
                    if (_showQR)
                      SizedBox(
                        width: size.width * 0.1,
                      ),
                    if (_showQR)
                      CustomElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showQR = false;
                            qrController!.pauseCamera();
                          });
                        },
                        color: MaterialStatePropertyAll(Colors.grey.shade300),
                        child: const Text(
                          'Stop',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
