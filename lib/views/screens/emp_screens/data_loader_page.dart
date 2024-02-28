import 'dart:async';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/user_repo.dart';
import 'package:meals_management/views/screens/emp_screens/employee_home_view.dart';
import 'package:meals_management/views/screens/vendor_screen/vendor_home_view.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:upgrader/upgrader.dart';
import 'package:custom_widgets/src.dart';

class DataLoader extends StatefulWidget {
  const DataLoader({super.key});

  @override
  State<DataLoader> createState() => _DataLoader();
}

class _DataLoader extends State<DataLoader> with ConnectivityMixin {
  DateTime now = DateTime.now();

  // used to work with the selected dates in SfDateRangePicker
  DateRangePickerController datesController = DateRangePickerController();

  // used to modify QR view
  QRViewController? qrController;

  late StreamSubscription subscription;

  // to identify QR widget in widget tree
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  UserRepo userRepo = UserRepo();

  final sharedPreferences = sl.get<SharedPreferences>();

  static int cnt = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    print("did init${cnt++}");

    Provider.of<UserDataProvider>(context, listen: false).isLoading = true;

    if (!sharedPreferences.containsKey('employee_name')) {
      // await Provider.of<UserDataProvider>(context, listen: false)
      //     .getUserinfo('');
      await Provider.of<UserDataProvider>(context, listen: false)
          .getUserEventsData();
      await Provider.of<UserDataProvider>(context, listen: false).getHolidays();
      print('user data got');
    } else {
      if (sharedPreferences.getString('user_type') != 'V') {
        await Provider.of<UserDataProvider>(context, listen: false)
            .getUserEventsData();
        await Provider.of<UserDataProvider>(context, listen: false)
            .getHolidays();
      }
    }

    Provider.of<UserDataProvider>(context, listen: false)
        .setConnected(isConnected());

    if (sharedPreferences.getString('user_type') == 'V') {
      DateTime lastResetDate = sharedPreferences.containsKey('lastResetDate')
          ? DateTime.parse(sharedPreferences.getString('lastResetDate')!)
          : DateTime.now();
      if (!sharedPreferences.containsKey('lastResetDate')) {
        sharedPreferences.setString('lastResetDate', now.toString());
        sharedPreferences.setInt('employeeCount', 0);
        Provider.of<HomeStatusProvider>(context, listen: false)
            .setEmployeeCount(sharedPreferences.getInt('employeeCount') ?? 0);
      } else if (now.day != lastResetDate.day) {
        sharedPreferences.setString('lastResetDate', now.toString());
        sharedPreferences.setInt('employeeCount', 0);
        Provider.of<HomeStatusProvider>(context, listen: false)
            .setEmployeeCount(sharedPreferences.getInt('employeeCount') ?? 0);
      } else {
        Provider.of<HomeStatusProvider>(context, listen: false)
            .setEmployeeCount(sharedPreferences.getInt('employeeCount') ?? 0);
      }
    }
    Provider.of<UserDataProvider>(context, listen: false).isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    print(sharedPreferences.getString('user_type'));
    
    return sharedPreferences.getString('employee_name')==null? CustomWidgets.CustomCircularLoader():  sharedPreferences.getString('user_type') == 'E'||sharedPreferences.getString('user_type') == 'A'
        ? UpgradeAlert(
            child: EmployeeHomeView(
            initData: initData,
          ))
        : UpgradeAlert(child: VendorHomeView());
  }
}
