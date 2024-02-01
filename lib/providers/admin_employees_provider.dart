import 'package:flutter/material.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class AdminEmployeesProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, dynamic>> _empData = [];
  List<dynamic> empList = [];
  bool _isSearching = false;
  UserModel? _user;
  bool _isMailLoading = false;

  List<Map<String, dynamic>> get getAllEmpData => _empData;
  List<dynamic> get getEmpList => empList;
  get isSearching => _isSearching;
  get isMailLoading => _isMailLoading;  
  String? get username => _user!.data!.empName;
  String? get userType => _user!.data!.userType;
  String? get empID => _user!.data!.empId;


  set isSearching(value) {
    _isSearching = value;
    notifyListeners();
  }

  set isMailLoading(value) {
    _isMailLoading = value;
    notifyListeners();
  }

  Future<void> setEmpList({String search = ''}) async {
    // var allEmpinfoList = await _db.getEmployees(search: search);
    // API method 6 for Get Request
    // here we fetch the entire column of names from company's empoyees table
    // then for each change in search text field we trigger that get method
    // empList = allEmpinfoList;
    isSearching = false;
    notifyListeners();
  }

  Future<void> setAllEmpData() async {
    // _empData = await _db.readUsers();
    // API method 7 for Get Request
    // we send the date to db using that date we filter rows in events table then we join that events table with
    // company's employees table using employee id in response we get a list of map(for each user with column names as keys and each row data
    // as values)  using this in the app we inject data into excel sheet accordingly.
    notifyListeners();
  }

  Future<void> setEmpDataWithID({String? empid}) async {
    // _user = await _db.readDataWithID(empid: empid);
    // here we can use API method 1 Get method
    notifyListeners();
  }

  Future<void> setEmpData() async {
    // _empData = await _db.readUsers();
    notifyListeners();
  }
}
