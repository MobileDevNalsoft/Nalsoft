import 'package:flutter/material.dart';
import 'package:meals_management/Repositories/user_repo.dart';
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class AdminEmployeesProvider extends ChangeNotifier {

   final UserRepo userRepo = UserRepo(dioClient2: sl());
  List<Map<String, dynamic>> _empData = [];
  List<dynamic> _alluserSearchList = [];
  bool _isSearching = false;
  UserModel? _user = UserModel();
  bool _isMailLoading = false;



  List<Map<String, dynamic>> get getAllEmpData => _empData;
  List<dynamic> get alluserSearchList => _alluserSearchList;
  bool get isSearching => _isSearching;
  bool get isMailLoading => _isMailLoading; 
  List<dynamic>?  _alluserList = [];
  String? get username => _user!.data!.empName;
  String? get userType => _user!.data!.userType;
  String? get empID => _user!.data!.empId;
  List<dynamic>? get getAllUserList => _alluserList;

   void setAllUserList() {
     _alluserList = [];
   }

  set isSearching(value) {
    _isSearching = value;
    notifyListeners();
  }

  set isMailLoading(value) {
    _isMailLoading = value;
    notifyListeners();
  }

  // Future<void> setEmpList({String search = ''}) async {
  //   // var allEmpinfoList = await _db.getEmployees(search: search);
  //   // API method 6 for Get Request
  //   // here we fetch the entire column of names from company's empoyees table
  //   // then for each change in search text field we trigger that get method
  //   // empList = allEmpinfoList;
  //   isSearching = false;
  //   notifyListeners();
  // }

  Future<void> getAllUsers(String date) async {
  ApiResponse apiResponse = await  userRepo.getAllUserData(date);   
   if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
        _alluserList = apiResponse.response!.data['data'].map((userdata) => Data.fromJson(userdata)).toList();

        }  
  }

     Future<void> getSearchData(String searchText) async{
      _isSearching=true;
      notifyListeners();
      ApiResponse apiResponse =
        await userRepo!.getSearchData(searchText);
      if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
        _alluserSearchList = apiResponse.response!.data['data'].map((userdata) => Data.fromJson(userdata)).toList(); 
        print(_alluserSearchList);
        _isSearching= false;
        notifyListeners();   

   } 
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
