import 'package:flutter/material.dart';
import 'package:mess_management/views/screens/adminHomePage.dart';
import 'package:mess_management/views/screens/digital_sign_page.dart';
import 'package:mess_management/views/screens/download.dart';
import 'package:mess_management/views/screens/employeeLunchStatus.dart';
import 'package:mess_management/views/screens/employees.dart';
import 'package:mess_management/views/screens/login_page.dart';
import 'package:mess_management/views/screens/preview_page.dart';
import 'package:mess_management/views/screens/updateUpcomingStatus.dart';
import 'package:mess_management/views/screens/userRegistration.dart';
import 'package:mess_management/views/screens/user_home_page.dart';

class RouteManagement {
  RouteManagement._();
  static const String homePage = '/homepage';
  static const String employees = '/employees';
  static const String employeeLunchStatus = '/employeeLunchStatus';
  static const String download = '/download';
  static const String adminHomePage = '/adminHomePage';
  static const String userRegistration = '/userRegistration';
  static const String updateUpcomingStatus = '/updateUpcomingStatus';
  
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/homepage':
        return MaterialPageRoute(builder: (_) => UserHomePage());
      case '/sign':
        return MaterialPageRoute(builder: (_) => SignPage());
      case '/preview':
        return MaterialPageRoute(builder: (_) => Preview());
      case '/userRegistration':
        return MaterialPageRoute(builder: (_) => UserRegistrationView());
      case '/adminHomePage':
        return MaterialPageRoute(builder: (_) => AdminHomePage());
      case '/employees':
        return MaterialPageRoute(builder: (_) => Employees());
      case '/download':
        return MaterialPageRoute(builder: (_) => Download());
      case '/employeeLunchStatus':
        return MaterialPageRoute(builder: (_) => EmployeeLunchStatus());
        
      case '/adminHomePage':
        return MaterialPageRoute(builder: (_) => AdminHomePage());
      case '/updateUpcomingStatus':
        return MaterialPageRoute(builder: (_) => UpdateLunchStatus());
      default:
        return null;
    }
  }
}
