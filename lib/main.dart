import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meals_management/inits/di_container.dart' as di;

import 'package:meals_management/providers/admin_employees_provider.dart';
import 'package:meals_management/providers/admin_generate_notification_provider.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/digital_signature_provider.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/utils/constants.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBgn6YsKh5YqVgFCV6NzMbfqfROqI29BUE",
          appId: "1:1066586839679:android:8f9eea5ae77f7472dd7d4a",
          messagingSenderId: "1066586839679",
          projectId: "meals-management-app-37e6a"));

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  messaging.subscribeToTopic("mobiles");
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => di.sl<UserDataProvider>()),
      ChangeNotifierProvider(create: (_) => di.sl<AuthenticationProvider>()),
      ChangeNotifierProvider<AdminEmployeesProvider>(
          create: (_) => AdminEmployeesProvider()),
      ChangeNotifierProvider<HomeStatusProvider>(
          create: (_) => HomeStatusProvider()),
      ChangeNotifierProvider<GenerateNotificationProvider>(
          create: (_) => GenerateNotificationProvider()),
    ],
    child: SafeArea(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteManagement.generateRoute,
            home:
                di.sl.get<SharedPreferences>().getString(AppConstants.TOKEN) == ''
                    ? LoginView()
                    : EmployeeHomeView())),
  ));
}
