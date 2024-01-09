
import 'package:flutter/material.dart';
import '../views/screens/admin_screens/admin_download_csv_view.dart';
import '../views/screens/admin_screens/admin_employee_lunch_status_view.dart';
import '../views/screens/admin_screens/admin_employees_view.dart';
import '../views/screens/admin_screens/admin_home_view.dart';
import '../views/screens/authentication/login_view.dart';
import '../views/screens/authentication/signup_view.dart';
import '../views/screens/emp_screens/employee_digital_sign_view.dart';
import '../views/screens/emp_screens/employee_preview_view.dart';
import '../views/screens/emp_screens/employee_update_upcoming_status_view.dart';
import '../views/screens/emp_screens/employee_home_view.dart';

class RouteManagement{
  RouteManagement._();

  static Route<dynamic>? generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/login_page' :
                  return MaterialPageRoute(builder: (_) => LoginView());
      case '/admin_homepage' :
                  return MaterialPageRoute(builder: (_) => AdminHomePage());
      case '/emp_homepage' :
                  return MaterialPageRoute(builder: (_) => EmployeeHomeView());
      case '/download_csv' :
                  return MaterialPageRoute(builder: (_) => Download());
      case '/admin_employees' :
                  return MaterialPageRoute(builder: (_) => Employees());
      case '/employee_lunch_status' :
                  return MaterialPageRoute(builder: (_) => EmployeeLunchStatus());
      case '/register' :
                  return MaterialPageRoute(builder: (_) => SignUpView());
      case '/update_upcoming_status' :
                  return MaterialPageRoute(builder: (_) => UpdateLunchStatus());
      case '/sign' :
                  return MaterialPageRoute(builder: (_) => DigitalSignView());
      case '/preview' :
                  return MaterialPageRoute(builder: (_) => Preview());
      default :
                  return null;
    }
  }
}