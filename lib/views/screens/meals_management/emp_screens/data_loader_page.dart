import 'dart:async';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/providers/meals_management/firebase_provider.dart';
import 'package:meals_management/providers/meals_management/home_status_provider.dart';
import 'package:meals_management/providers/meals_management/user_data_provider.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/employee_home_view.dart';
import 'package:meals_management/views/screens/meals_management/vendor_screen/vendor_home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class DataLoader extends StatefulWidget {
  const DataLoader({super.key});

  @override
  State<DataLoader> createState() => _DataLoader();
}

class _DataLoader extends State<DataLoader> with ConnectivityMixin {
  DateTime now = DateTime.now();

  final sharedPreferences = sl.get<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    Provider.of<UserDataProvider>(context, listen: false).isLoading = true;

    if (!sharedPreferences.containsKey('employee_name')) {
      await Provider.of<UserDataProvider>(context, listen: false)
          .getUserEventsData();
      await Provider.of<UserDataProvider>(context, listen: false).getHolidays();
    } else {
      if (sharedPreferences.getString('user_type') != 'V') {
        await Provider.of<UserDataProvider>(context, listen: false)
            .getUserEventsData();
        await Provider.of<UserDataProvider>(context, listen: false)
            .getHolidays();
      }
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
    }

    Provider.of<UserDataProvider>(context, listen: false)
        .setConnected(isConnected());
    Provider.of<UserDataProvider>(context, listen: false).isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString('user_type') == 'E' ||
            sharedPreferences.getString('user_type') == 'A'
        ? UpgradeAlert(
            child: EmployeeHomeView(
            initData: initData,
          ))
        : UpgradeAlert(child: VendorHomeView());
  }
}
