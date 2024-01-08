
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
      options: FirebaseOptions(apiKey: "AIzaSyBuP6IMcXszCFZjCHHcjp87RXLUkOzFjq0", appId: "1:885666560200:android:06660e323321d815c0cdfd", messagingSenderId: "885666560200",projectId: "mess-management-1de8c")
  );
  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
      ChangeNotifierProvider<HomePageModel>(create: (context) => HomePageModel()),
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

