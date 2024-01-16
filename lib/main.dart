import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/providers/admin_employees_provider.dart';
import 'package:meals_management_with_firebase/providers/auth_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_digital_sign_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_home_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_lunch_status_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_update_upcoming_status_provider.dart';
import 'package:meals_management_with_firebase/providers/events_provider.dart';
import 'package:meals_management_with_firebase/providers/universal_data_provider.dart';
import 'package:meals_management_with_firebase/providers/user_data_provider.dart';
import 'package:meals_management_with_firebase/route_management/route_management.dart';
import 'package:meals_management_with_firebase/views/screens/authentication/login_view.dart';
import 'package:meals_management_with_firebase/views/screens/emp_screens/employee_home_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBgn6YsKh5YqVgFCV6NzMbfqfROqI29BUE",
          appId: "1:1066586839679:android:8f9eea5ae77f7472dd7d4a",
          messagingSenderId: '1066586839679',
          projectId: "meals-management-app-37e6a"));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
      ChangeNotifierProvider<EmployeeHomeProvider>(
          create: (context) => EmployeeHomeProvider()),
      ChangeNotifierProvider<StatusProvider>(
          create: (context) => StatusProvider()),
      ChangeNotifierProvider<AdminEmployeesProvider>(
          create: (context) => AdminEmployeesProvider()),
      ChangeNotifierProvider<UniversalDataProvider>(
          create: (context) => UniversalDataProvider()),
      ChangeNotifierProvider<UserDataProvider>(
          create: (context) => UserDataProvider()),
      ChangeNotifierProvider<EventsProvider>(
          create: (context) => EventsProvider()),
      ChangeNotifierProvider<SignatureProvider>(
          create: (context) => SignatureProvider()),
      ChangeNotifierProvider<EmployeeLunchStatusProvider>(
          create: (context) => EmployeeLunchStatusProvider()),
    ],
    child: SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteManagement.generateRoute,
        home: sharedPreferences.getString("islogged") == "true"
            ? const EmployeeHomeView()
            : const LoginView(),
      ),
    ),
  ));
}
