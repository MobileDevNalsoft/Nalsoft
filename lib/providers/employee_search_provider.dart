import 'package:flutter/material.dart';
import 'package:meals_management/services/database_service.dart';


class EmployeesSearchProvider extends ChangeNotifier {
  final DatebaseServices _db = DatebaseServices();

  List<dynamic> empList = [];
  

  Future<void> setEmpList({String search=''}) async {
    var allEmpinfoList = await _db.getEmployees(search: search);
    print(allEmpinfoList);
    empList=allEmpinfoList;
    // empList = allEmpinfoList.map((e) => e['username']).toList();

    notifyListeners();
  }

  List<dynamic> get getEmpList => empList;
}