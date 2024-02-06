import 'package:flutter/material.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/views/screens/network_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meals_management/inits/di_container.dart' as di;
import 'package:upgrader/upgrader.dart';

import '../../utils/constants.dart';
import 'authentication/login_view.dart';
import 'emp_screens/home_view.dart';

class ConnectionBasedNavigator extends StatefulWidget{
  ConnectionBasedNavigator({super.key});

  @override
  State<ConnectionBasedNavigator> createState() => _ConnectionBasedNavigatorState();
}

class _ConnectionBasedNavigatorState extends State<ConnectionBasedNavigator> with ConnectivityMixin{

  @override
  Widget build(BuildContext context){
    return StreamBuilder<bool>(
      stream: connectivityStream,
      initialData: false, // Assume connected initially
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;

        // You can conditionally load different pages based on connectivity
        return isConnected ? di.sl.get<SharedPreferences>().getString(AppConstants.TOKEN) == ''
            ? UpgradeAlert(child: LoginView())
            : UpgradeAlert(child: EmployeeHomeView()) : NetworkError();
      },
    );
  }
}