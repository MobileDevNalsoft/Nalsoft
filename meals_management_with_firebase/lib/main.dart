import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/providers/admin_download_csv_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_home_provider.dart';
import 'package:meals_management_with_firebase/providers/employee_update_upcoming_status_provider.dart';
import 'package:meals_management_with_firebase/providers/login_provider.dart';
import 'package:meals_management_with_firebase/providers/signup_provider.dart';
import 'package:meals_management_with_firebase/route_management/route_management.dart';
import 'package:meals_management_with_firebase/views/screens/authentication/login_view.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyC6V3jGDNvk_v1Vz6TjCxK_4493ynW5Zt8", appId: "1:510917770454:android:0830bc879ebe006fee1d77", messagingSenderId: '510917770454', projectId: "meals-management-5441b")
  );
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider()),
          ChangeNotifierProvider<HomePageProvider>(create: (context) => HomePageProvider()),
          ChangeNotifierProvider<SignupProvider>(create: (context) => SignupProvider()),
          ChangeNotifierProvider<DownloadProvider>(create: (context) => DownloadProvider()),
          ChangeNotifierProvider<StatusProvider>(create: (context) => StatusProvider()),
        ],
        child: SafeArea(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: RouteManagement.generateRoute,
              home: LoginView()
          ),
        ),
      )
  );
}

