import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/providers/admin_download_csv_provider.dart';
import 'package:meals_management_with_firebase/providers/admin_employees_provider.dart';
import 'package:meals_management_with_firebase/providers/admin_home_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_home_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_update_upcoming_status_provider.dart';
import 'package:meals_management_with_firebase/providers/login_provider.dart';
import 'package:meals_management_with_firebase/providers/signup_provider.dart';
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
      ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider()),
      ChangeNotifierProvider<HomePageProvider>(
          create: (context) => HomePageProvider()),
      ChangeNotifierProvider<SignupProvider>(
          create: (context) => SignupProvider()),
      ChangeNotifierProvider<DownloadProvider>(
          create: (context) => DownloadProvider()),
      ChangeNotifierProvider<StatusProvider>(
          create: (context) => StatusProvider()),
      ChangeNotifierProvider<AdminHomeProvider>(
          create: (context) => AdminHomeProvider()),
      ChangeNotifierProvider<AdminEmployeesProvider>(
          create: (context) => AdminEmployeesProvider()),
    ],
    child: SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteManagement.generateRoute,
        home: sharedPreferences.getString("islogged") == "true"
            ? EmployeeHomeView()
            : LoginView(),
      ),
    ),
  ));
}
