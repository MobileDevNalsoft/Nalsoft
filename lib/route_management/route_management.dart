import 'package:flutter/material.dart';
import 'package:meals_management/views/app_navigation.dart';
import 'package:meals_management/views/notifications.dart';
import 'package:meals_management/views/screens/admin_screens/admin_employee_lunch_status_view.dart';
import 'package:meals_management/views/screens/admin_screens/admin_employees_view.dart';
import 'package:meals_management/views/screens/admin_screens/admin_home_view.dart';
import 'package:meals_management/views/screens/admin_screens/admin_generate_notification_view.dart';
import 'package:meals_management/views/screens/authentication/login_view.dart';
import 'package:meals_management/views/screens/emp_screens/data_loader_page.dart';
import 'package:meals_management/views/screens/emp_screens/employee_home_view.dart';
import 'package:meals_management/views/screens/emp_screens/employee_preview_view.dart';
import 'package:meals_management/views/screens/emp_screens/employee_update_upcoming_status_view.dart';

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
  static const String dataLoader = '/dataLoader';
  static const String notifications = '/notifications';
  static const String appNavigation = 'appNavigation';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginView());
      case employeeHomePage:
        return MaterialPageRoute(builder: (_) => EmployeeHomeView());
      case previewPage:
        return MaterialPageRoute(builder: (_) => Preview());
      case adminHomePage:
        return MaterialPageRoute(builder: (_) => AdminHomePage());
      case adminEmployees:
        return MaterialPageRoute(builder: (_) => EmployeeSearch());
      case employeeLunchStatus:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          final empid = args['empid'];
          final username = args['username'];
          return EmployeeLunchStatus(
            userName: username,
            empID: empid,
          );
        });
      case updateUpcomingStatus:
        return MaterialPageRoute(builder: (_) {
          final args = settings.arguments as Map<String, dynamic>;
          final initData = args["initData"] as Function;
          return UpdateLunchStatus(
            initData: initData,
          );
        });
      case employeeSearch:
        return MaterialPageRoute(builder: (_) => EmployeeSearch());
      case generateNotification:
        return MaterialPageRoute(builder: (_) => GenerateNotification());
      case dataLoader:
        return MaterialPageRoute(builder: (_) => DataLoader());
      case notifications:
        return MaterialPageRoute(builder: (_) => NotificationsView());
      case appNavigation:
        return MaterialPageRoute(builder: (_) => AppNavigation());
      default:
        return null;
    }
  }
}
