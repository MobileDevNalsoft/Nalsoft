import 'package:flutter/material.dart';
import 'package:meals_management/services/database_service.dart';


class EmployeesSearchProvider extends ChangeNotifier {
  final DatebaseServices _db = DatebaseServices();

  List<dynamic> empList = [];
  bool _isSearching =false;

  set isSearching(value) {
    _isSearching=value;
    notifyListeners();
  }
  get isSearching=>_isSearching;
  
  Future<void> setEmpList({String search=''}) async {
    var allEmpinfoList = await _db.getEmployees(search: search);
    print(allEmpinfoList);
    empList=allEmpinfoList;
    // empList = allEmpinfoList.map((e) => e['username']).toList();
    isSearching=false;
    notifyListeners();
  }

  List<dynamic> get getEmpList => empList;
}