import 'package:flutter/material.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class UserDataProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  // for UI updations related to user data
  UserModel? _user;
  List<DateTime> _optedDates = [];
  List<DateTime> _notOptedDates = [];
  Map<DateTime, String> _notOptedDatesWithReasons = {};

  // getting user data from firestore collection
  Future<void> getUserFromDB() async {
    _user = await _db.readData();
    notifyListeners();
  }

  void setOptedDates({List<DateTime>? dates}) {
    if (dates == null) {
      _optedDates = _user!.opted.map((date,link) => DateTime.parse(e).);
      notifyListeners();
    } else {
      _notOptedDates.remove(dates[0]);
      _optedDates = _optedDates + dates;
      notifyListeners();
    }
  }

  void setNotOptedDates({List<DateTime>? dates}) {
    if (dates == null) {
      _notOptedDates =
          _user!.notOpted.keys.map((e) => DateTime.parse(e)).toList();
      notifyListeners();
    } else {
      dates.forEach((e) => _optedDates.remove(e));
      _notOptedDates = _notOptedDates + dates;
      notifyListeners();
    }
  }

  void removeNotOptedDate(DateTime? date) {
    _notOptedDates.remove(date);
    notifyListeners();
  }

  Future<void> getNotOptedWithReasonsFromDB() async {
    _notOptedDatesWithReasons = await _db.readNotOptedWithReasons();
    notifyListeners();
  }

  String? get getUsername => _user!.userName;
  bool? get getIsAdmin => _user!.isAdmin;
  String? get getFloor => _user!.floor;
  String? get getEmpID => _user!.employee_id;
  List<DateTime> get getOpted => _optedDates;
  List<DateTime> get getNotOpted => _notOptedDates;
  Map<DateTime, String> get getNotOptedWithReasons => _notOptedDatesWithReasons;

  // pushes date to db to opted or notOpted category
  void pushDate(
      {required DateTime date, required int radioValue, String? reason}) {
    _db.pushDatetoDB(date: date, radioValue: radioValue, reason: reason);
  }

  // pushes dates to db to notopted category
  void pushDates(
      {required List<DateTime> dates,
      required int radioValue,
      String? reason}) {
    _db.pushDatestoDB(dates: dates, radioValue: radioValue, reason: reason);
  }

  Future<void> removeNotOptedDateFromDB(DateTime date) async {
    _db.removeDateFromDb(date);
  }
}
