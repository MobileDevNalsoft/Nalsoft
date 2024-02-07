import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meals_management/network_handler_mixin/network_handler.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_events_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/repositories/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  final UserEventsRepo? userEventsRepo;
  final UserRepo? userRepo;
  final SharedPreferences? sharedPreferences;

  UserDataProvider({this.userRepo, this.userEventsRepo, this.sharedPreferences});

  // for UI updations related to user data
  UserModel? _user;
  List<Dates> _optedDates = [];
  List<Dates> _notOptedDates = [];
  List<dynamic> _holidays = [];
  UserEventsModel? _userEventsModel;
  bool _isAlreadyScanned = false;
  List<UserModel> _alluserSearchList=[];
  bool _isSearching = false;
  bool _connected = true;
  bool eventsPresent = false;
  bool isAdminEmployeeDataPresent = false;
  bool isLoading = false;
  // getters
  List<dynamic> get holidays => _holidays;
  bool get isSearching => _isSearching;
  UserModel get getUserData => _user!;
  List<Dates> get getOpted => _optedDates;
  List<Dates> get getNotOpted => _notOptedDates;
  bool get getIsAlreadyScanned => _isAlreadyScanned;
  bool get getConnected => _connected;
  // Stream<bool> get isDataPresentStream => _isDataPresentController.stream; 

    set isSearching(value) {
    _isSearching = value;
    notifyListeners();
  }

  void setConnected(value){
      _connected = value;
      notifyListeners();
  }

  // void setStream(){
  //   _isDataPresentController.add(eventsPresent);
  // }
  // getting user data from firestore collection
  Future<void> getUserinfo(String? username) async {

    String username = "raviteja.singamsetty@nalsoft.net";
    ApiResponse apiResponse = await userRepo!.getUserinfo(username);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _user = UserModel.fromJson(apiResponse.response!.data);
      sharedPreferences!.setString('employee_name', _user!.data!.empName!);
      sharedPreferences!.setString('employee_id', _user!.data!.empId!);
      sharedPreferences!.setString('employee_department', _user!.data!.department!);
      sharedPreferences!.setString('user_type', _user!.data!.userType!);
    }
    print(_user);
    notifyListeners();
  }

  Future<void> updateUserEvents(List<Map<String, dynamic>> dates, bool isOpted) async {
    
    print("Dates");
    print(dates.toString());
    isLoading = true;
    ApiResponse apiResponse = await userEventsRepo!.updateUserEvents(sharedPreferences!.getString('employee_id')!, dates,isOpted);
    if(apiResponse.response!= null && apiResponse.response!.statusCode == 200){
      isOpted?_optedDates.add(dates.first['date']):dates.forEach((element) {_notOptedDates.add(Dates.fromJson(element));});
    print(apiResponse);
    isLoading = false;
    eventsPresent=true;
    // _isDataPresentController.add(eventsPresent);
    // print("datastream inside provider $isDataPresentStream");
    notifyListeners();
    }else{
     _isAlreadyScanned = true;
      notifyListeners();
    }
   
  }

  void setScanned(bool isscanned){

    _isAlreadyScanned = isscanned;
    notifyListeners();
  }

  Future<void> getHolidays() async {
      ApiResponse apiResponse =
        await userEventsRepo!.getHolidays();
         if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
        print("holidays${apiResponse.response!.data}");
          _holidays=apiResponse.response!.data["dates"].map((date)=>date["date"]).toList();
          print(_holidays);
          notifyListeners();
        }
  }

Future<void> getUserEventsData({String? empID}) async {
ApiResponse apiResponse;
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

Future<void> deleteUserEvents(List dates) async {
    isLoading = true;
    print(_notOptedDates);
    ApiResponse apiResponse =
        await userEventsRepo!.deleteUserEvents(sharedPreferences!.getString('employee_id')!,dates);
    print(apiResponse.response!.data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
          print(apiResponse.response!.data);
          dates.forEach((element) {
            _notOptedDates.removeWhere((date) => date.date==element["date"]);
          });
          isLoading = false;
      notifyListeners();
    }
    }




}