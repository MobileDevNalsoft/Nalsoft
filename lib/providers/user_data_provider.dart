import 'package:flutter/material.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class UserDataProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  // for UI updations related to user data
  UserModel? _user;
  List<dynamic> _optedDates = [];
  Map<String, dynamic> _notOptedDatesWithReasons = {};
  List<dynamic> _holidays = [];

  // gets
  List<dynamic> get getHolidays => _holidays;
  String? get getUsername => _user!.userName;
  bool? get getIsAdmin => _user!.isAdmin;
  String? get getFloor => _user!.floor;
  String? get getEmpID => _user!.employee_id;
  List<dynamic> get getOpted => _optedDates;
  Map<String, dynamic> get getNotOptedWithReasons => _notOptedDatesWithReasons;

  // getting user data from firestore collection
  Future<void> getUserFromDB() async {
    _user = await _db.readData();
    // API call 1 for Get Request
      // when user logs in to app for the first time we will store his mail id in shared preferences then
      // using that mail id(we send that mail id in get method) as a primary key we will fetch data from both company's employees table and events table 
      // at the same time and we place the relevant data in our app's usermodel accordingly 
    notifyListeners();
  }

  Future<bool> pushOptedDate({String? uid}) async {
    bool isAlreadyScanned = await _db.pushOpted(uid);
    // API call 5 for Post Request
      // we send the mail id and check if this date present in the table with status as 1(i.e opted)
      // we Get a boolean value in return. meanwhile we insert that row into table
    return isAlreadyScanned;
    // discuss about strean => ui updations when data changes in events table in database
    // can we create seperate table for each user with their mail id as table name
  }

  void setOptedDates({DateTime? date}) {
    if (date == null) {
      _optedDates = _user!.opted;
      notifyListeners();
      // we will get this from the model after API call 1 is a success
    } else {
      _optedDates.add(date.toString().substring(0, 10));
      notifyListeners();
    }
  }

  void setNotOptedDatesWithReason({List<DateTime>? dates, String? reason}) {
    if (dates == null) {
      _notOptedDatesWithReasons = _user!.notOpted;
      notifyListeners();
      // we will get this from the model after API call 1 is a success
    } else {
      dates.forEach((date) {
        _notOptedDatesWithReasons.remove(date.toString().substring(0, 10));
        _notOptedDatesWithReasons[date.toString().substring(0, 10)] = reason;
      });
      notifyListeners();
      _db.pushNotOpted(_notOptedDatesWithReasons);
      // API call 3 for Post Request 
        // we send a map with dates as keys and reasons as values
        // and we insert those as rows in events table with mail id,while inserting we set status as not opted(i.e 0)
    }
  }

  void removeNotOptedDate(List<DateTime> dates) {
    _notOptedDatesWithReasons
        .removeWhere((key, value) => dates.contains(DateTime.parse(key)));
    _db.pushNotOpted(_notOptedDatesWithReasons);
    notifyListeners();
    // API call 4 for Post Request
      // we send a map with dates as keys and reasons as values
      // and we delete those rows in events table using mail id in shared preferences
  }

  Future<void> setHolidays() async {
    _holidays = await _db.readHolidays();
    // API call 2 for Get Request for holiday dates
  }
}