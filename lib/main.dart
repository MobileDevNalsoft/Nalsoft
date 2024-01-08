
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_management/providers/downloadProvider.dart';
import 'package:mess_management/providers/emp_home_provider.dart';
import 'package:mess_management/providers/login_provider.dart';
import 'package:mess_management/views/screens/login_page.dart';
import 'package:mess_management/views/screens/route_management.dart';
import 'package:provider/provider.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyBgn6YsKh5YqVgFCV6NzMbfqfROqI29BUE", appId: "1:1066586839679:android:8f9eea5ae77f7472dd7d4a", messagingSenderId: "1066586839679",projectId: "meals-management-app-37e6a")
  );
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
      ChangeNotifierProvider<HomePageProvider>(create: (context) => HomePageProvider()),
      ChangeNotifierProvider<DownloadProvider>(create: (context) => DownloadProvider()),
    ],
    child: SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RouteManagement.generateRoute,
        home: LoginPage()
      ),
    ),
  )
);

}

