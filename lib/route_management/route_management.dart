import 'package:flutter/material.dart';
import 'package:meals_management/views/screens/admin_screens/admin_employee_lunch_status_view.dart';
import 'package:meals_management/views/screens/admin_screens/admin_employees_view.dart';
import 'package:meals_management/views/screens/admin_screens/admin_home_view.dart';
import 'package:meals_management/views/screens/admin_screens/admin_generate_notification_view.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';
import 'package:meals_management/views/screens/emp_screens/employee_preview_view.dart';
import 'package:meals_management/views/screens/emp_screens/employee_update_upcoming_status_view.dart';
import 'package:meals_management/views/screens/network_error.dart';

class RouteManagement {
  RouteManagement._();
  static const String loginPage = '/login_page';
  static const String employeeHomePage = '/homepage';
  static const String adminEmployees = '/employees';
  static const String employeeLunchStatus = '/employeeLunchStatus';
  static const String adminHomePage = '/adminHomePage';
  static const String signUp = '/userRegistration';
  static const String updateUpcomingStatus = '/updateUpcomingStatus';
  static const String previewPage = '/preview';
  static const String employeeSearch = '/employeeSearch';
  static const String digitalSignature = '/sign';
  static const String generateNotification = '/generateNotification';
  static const String network_error = '/network_error';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login_page':
        return MaterialPageRoute(builder: (_) => LoginView());
      case '/homepage':
        return MaterialPageRoute(builder: (_) => EmployeeHomeView());
      case '/preview':
        return MaterialPageRoute(builder: (_) => Preview());
      case '/adminHomePage':
        return MaterialPageRoute(builder: (_) => AdminHomePage());
      case '/employees':
        return MaterialPageRoute(builder: (_) => EmployeeSearch());
      case '/employeeLunchStatus':
        return MaterialPageRoute(builder : (_) { 
            final args = settings.arguments as Map<String, dynamic>;
          final empid = args['empid'];
         final username = args['username'];
          return EmployeeLunchStatus(userName:username,empID: empid,);
        });
      case '/updateUpcomingStatus':
        return MaterialPageRoute(builder: (_) {
            final args = settings.arguments as Map<String, dynamic>;
            final intiData=args["initData"] as Function;
        return UpdateLunchStatus(initData: intiData,);});
      case '/employeeSearch':
        return MaterialPageRoute(builder: (_) => EmployeeSearch());
      case '/generateNotification':
        return MaterialPageRoute(builder: (_) => GenerateNotification());
      case '/network_error':
        return MaterialPageRoute(builder: (_) => NetworkError());
      default:
        return null;
    }
  }
}
