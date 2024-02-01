import 'package:flutter/material.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_events_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class UserDataProvider extends ChangeNotifier {
  final UserEventsRepo? userEventsRepo; 

  // for UI updations related to user data
  UserModel? _user;
  List<dynamic> _optedDates = [];
  Map<String, dynamic> _notOptedDatesWithReasons = {};
  List<dynamic> _holidays = [];
  UserEventsModel? _userEventsModel;

  UserDataProvider({ this.userEventsRepo});

  // getters
  List<dynamic> get getHolidays => _holidays;
  String? get getUsername => "ab";
  // _user!.data!.empName;
  String? get getIsAdmin => 'E';
  // _user!.data!.userType;
  String? get getEmpID => "00012";

  // _user!.data!.empId;
  List<dynamic> get getOpted => _optedDates;
  Map<String, dynamic> get getNotOptedWithReasons => _notOptedDatesWithReasons;


  Future<void> setHolidays() async {
    // _holidays = await _db.readHolidays();
    // API method 2 for Get Request for holiday dates
  }

  Future<void> getUserEventsData()async {
    print("before response");

    ApiResponse apiResponse = await userEventsRepo!.getUserEventsData(00032);
    print("after response");
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {

       _userEventsModel = UserEventsModel.fromJson(apiResponse.response!.data);
        print(_userEventsModel!.data!.notOpted);
        _userEventsModel!.data!.optedDates!.forEach((element) { _optedDates.add(element.date);});
       print(_optedDates);
       notifyListeners();
    } 
  }


}
