import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/inits/di_container.dart' as di;
import 'package:meals_management/providers/meals_management/admin_employees_provider.dart';
import 'package:meals_management/providers/meals_management/firebase_provider.dart';
import 'package:meals_management/providers/meals_management/auth_provider.dart';
import 'package:meals_management/providers/meals_management/home_status_provider.dart';
import 'package:meals_management/providers/meals_management/user_data_provider.dart';
import 'package:meals_management/providers/meeting_rooms_management/home_view_provider.dart';
import 'package:meals_management/providers/meeting_rooms_management/meeting_room_provider.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/app_navigation.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/data_loader_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Upgrader.clearSavedSettings();

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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<UserDataProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthenticationProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AdminEmployeesProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<FirebaseProvider>()),
        ChangeNotifierProvider<HomeStatusProvider>(
            create: (_) => HomeStatusProvider()),
        ChangeNotifierProvider(create: (_) => HomeViewProvider()),
        ChangeNotifierProvider(create: (_) => MeetingRoomProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: RouteManagement.generateRoute,
          home: !di.sl.get<SharedPreferences>().containsKey('employee_name')
              ? UpgradeAlert(child: LoginView())
              : AppNavigation()),
    ));
  });
}
