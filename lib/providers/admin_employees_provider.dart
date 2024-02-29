import 'package:flutter/material.dart';
import 'package:meals_management/Repositories/user_repo.dart';
import 'package:meals_management/inits/di_container.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_events_model.dart';

class AdminEmployeesProvider extends ChangeNotifier {

  final UserEventsRepo? userEventsRepo;
  final SharedPreferences? sharedPreferences;

  AdminEmployeesProvider({this.userEventsRepo, this.sharedPreferences});

   final UserRepo userRepo = UserRepo(dioClient2: sl());
  List<Map<String, dynamic>> _empData = [];
  List<dynamic> _alluserSearchList = [];
  bool _isSearching = false;
  UserModel? _user = UserModel();
  bool _isMailLoading = false;
 List<Dates> _optedDates = [];
 List<Dates> _notOptedDates = [];
 UserEventsModel? _userEventsModel;
 bool eventsPresent = false;
 bool isAdminEmployeeDataPresent = false;
 bool isLoading = false;



  List<Map<String, dynamic>> get getAllEmpData => _empData;
  List<dynamic> get alluserSearchList => _alluserSearchList;
  bool get isSearching => _isSearching;
  bool get isMailLoading => _isMailLoading; 
  List<dynamic>?  _alluserList = [];
  String? get username => _user!.data!.empName;
  String? get userType => _user!.data!.userType;
  String? get empID => _user!.data!.empId;
  List<dynamic>? get getAllUserList => _alluserList;
  UserModel get getUserData => _user!;
  List<Dates> get getOpted => _optedDates;
  List<Dates> get getNotOpted => _notOptedDates;

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

   Future<void> getUserEventsData({String? empID}) async {
     ApiResponse apiResponse;
     print(empID);
     if (empID==null)
     {  apiResponse =
     await userEventsRepo!.getUserEventsData(sharedPreferences!.getString('employee_id')!);}
     else{ apiResponse =
     await userEventsRepo!.getUserEventsData(empID);}

     if (apiResponse.response != null &&
         apiResponse.response!.statusCode == 200) {
       _userEventsModel = UserEventsModel.fromJson(apiResponse.response!.data);
       _optedDates = _userEventsModel!.data!.optedDates!;

       _notOptedDates = _userEventsModel!.data!.notOpted!;


       eventsPresent=true;
       isAdminEmployeeDataPresent=true;
       // _isDataPresentController.add(eventsPresent);
       // print("datastream inside provider $isDataPresentStream");
       isLoading=false;
       print(_optedDates);
       print(_userEventsModel!.data!.notOpted!);
       notifyListeners();
     }
   }
   Future<void> getUserinfo(String? username) async {

     ApiResponse apiResponse = await userRepo.getUserinfo(username!);

     if (apiResponse.response != null &&
         apiResponse.response!.statusCode == 200) {
       _user = UserModel.fromJson(apiResponse.response!.data);
     }
     print(_user);
     notifyListeners();
   }


}
