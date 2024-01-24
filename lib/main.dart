import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/inits/init.dart';
import 'package:meals_management/providers/admin_employees_provider.dart';
import 'package:meals_management/providers/auth_provider.dart';
import 'package:meals_management/providers/digital_signature_provider.dart';
import 'package:meals_management/providers/home_status_provider.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Initialize().setup();
  SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBgn6YsKh5YqVgFCV6NzMbfqfROqI29BUE",
          appId: "1:1066586839679:android:8f9eea5ae77f7472dd7d4a",
          messagingSenderId: "1066586839679",
          projectId: "meals-management-app-37e6a"));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SignatureProvider>(
          create: (context) => SignatureProvider()),
      ChangeNotifierProvider<UserDataProvider>(
          create: (context) => UserDataProvider()),
      ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider()),
      ChangeNotifierProvider<AdminEmployeesProvider>(
          create: (context) => AdminEmployeesProvider()),
      ChangeNotifierProvider<HomeStatusProvider>(
          create: (context) => HomeStatusProvider()),
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
