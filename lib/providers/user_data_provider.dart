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
    notifyListeners();
  }

  Future<bool> pushOptedDate({String? uid}) async {
    bool isAlreadyScanned = await _db.pushOpted(uid);
    return isAlreadyScanned;
  }

  void setOptedDates() {
    _optedDates = _user!.opted;
    notifyListeners();
  }

  void setNotOptedDatesWithReason({List<DateTime>? dates, String? reason}) {
    if (dates == null) {
      _notOptedDatesWithReasons = _user!.notOpted;
      notifyListeners();
    } else {
      dates.forEach((e) {
        _notOptedDatesWithReasons.remove(e.toString());
        _notOptedDatesWithReasons[e.toString()] = reason;
      });
      notifyListeners();
      _db.pushNotOpted(_notOptedDatesWithReasons);
    }
  }

  void removeNotOptedDate(DateTime? date) {
    _notOptedDatesWithReasons.remove(date.toString());
    _db.pushNotOpted(_notOptedDatesWithReasons);
    notifyListeners();
  }

  Future<void> setHolidays() async {
    _holidays = await _db.readHolidays();
  }
}
