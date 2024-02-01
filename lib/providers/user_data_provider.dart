import 'package:flutter/material.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_events_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/repositories/user_repo.dart';

class UserDataProvider extends ChangeNotifier {
  final UserEventsRepo? userEventsRepo;
  final UserRepo? userRepo;

  UserDataProvider({this.userRepo, this.userEventsRepo});

  // for UI updations related to user data
  UserModel? _user;
  List<dynamic> _optedDates = [];
  Map<String, dynamic> _notOptedDatesWithReasons = {};
  List<dynamic> _holidays = [];
  UserEventsModel? _userEventsModel;


  // getters
  List<dynamic> get getHolidays => _holidays;

  UserModel get getUserData => _user!;
  List<dynamic> get getOpted => _optedDates;
  Map<String, dynamic> get getNotOptedWithReasons => _notOptedDatesWithReasons;

  // getting user data from firestore collection
  Future<void> getUserinfo(String? username) async {
    String username = "raviteja.singamsetty@nalsoft.net";
    ApiResponse apiResponse = await userRepo!.getUserinfo(username);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _user = UserModel.fromJson(apiResponse.response!.data);
    }
    notifyListeners();
  }

  Future<void> updateUserEvents(List<Map<String, dynamic>> dates) async {
    ApiResponse apiResponse = await userEventsRepo!.updateUserEvents(_user!.data!.empId!, dates!);
    print(apiResponse);
    notifyListeners();
  }

  void setOptedDates({DateTime? date}) {
    if (date == null) {
      // _optedDates = _user!.opted;
      notifyListeners();
      // we will get this from the model after API method 1 is a success
    } else {
      _optedDates.add(date.toString().substring(0, 10));
      notifyListeners();
    }
  }

  // void setNotOptedDatesWithReason({List<DateTime>? dates, String? reason}) {
  //   if (dates == null) {
  //     // _notOptedDatesWithReasons = _user!.notOpted;
  //     notifyListeners();
  //     // we will get this from the model after API method 1 is a success
  //   } else {
  //     dates.forEach((date) {
  //       _notOptedDatesWithReasons.remove(date.toString().substring(0, 10));
  //       _notOptedDatesWithReasons[date.toString().substring(0, 10)] = reason;
  //     });
  //     notifyListeners();
  //     userEventsRepo!.pushNotOpted(_notOptedDatesWithReasons);
  //     // API method 3 for Post Request
  //     // we send a map with dates as keys and reasons as values
  //     // and we insert those as rows in events table with mail id,while inserting we set status as not opted(i.e 0)
  //   }
  // }

  // // void removeNotOptedDate(List<DateTime> dates) {
  // //   _notOptedDatesWithReasons
  // //       .removeWhere((key, value) => dates.contains(DateTime.parse(key)));
  // //   userEventsRepo!.pushNotOpted(_notOptedDatesWithReasons);
  // //   notifyListeners();
  //   // API method 4 for Post Request
  //   // we send a map with dates as keys and reasons as values
  //   // and we delete those rows in events table using mail id in shared preferences
  // }

  Future<void> setHolidays() async {
    // _holidays = await _db.readHolidays();
    // API method 2 for Get Request for holiday dates
  }

  Future<void> getUserEventsData()async {
    print("before response");

    ApiResponse apiResponse = await userEventsRepo!.getUserEventsData(_user!.data!.empId!);
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
