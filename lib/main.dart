
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/providers/department_provider.dart';
import 'package:meals_management/providers/download_provider.dart';
import 'package:meals_management/providers/emp_home_provider.dart';
import 'package:meals_management/providers/events_provider.dart';
import 'package:meals_management/providers/login_provider.dart';
import 'package:meals_management/providers/update_upcoming_status_provider.dart';
import 'package:meals_management/providers/user_signup_provider.dart';
import 'package:meals_management/views/screens/login_page.dart';  
import 'package:meals_management/views/screens/route_management.dart';
import 'package:meals_management/views/screens/user_home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
   WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences? sharedPreferences= await SharedPreferences.getInstance();
   await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyBgn6YsKh5YqVgFCV6NzMbfqfROqI29BUE", appId: "1:1066586839679:android:8f9eea5ae77f7472dd7d4a", messagingSenderId: "1066586839679",projectId: "meals-management-app-37e6a")
  );
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
      ChangeNotifierProvider<HomePageProvider>(create: (context) => HomePageProvider()),
      ChangeNotifierProvider<DownloadProvider>(create: (context) => DownloadProvider()),
      ChangeNotifierProvider<StatusProvider>(create: (context) => StatusProvider()),
      ChangeNotifierProvider<EventsProvider>(create: (context) => EventsProvider()),
        ChangeNotifierProvider<SignUpProvider>(create: (context) => SignUpProvider()),
        ChangeNotifierProvider<DeptProvider >(create: (context) => DeptProvider()),
    ],
    child: SafeArea(
      child: MaterialApp( 
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        onGenerateRoute: RouteManagement.generateRoute, 
         home: sharedPreferences!.getString("islogged") == "true" ? EmployeeHomeView() : LoginView(),
      ),
    ),
  )
);
}

