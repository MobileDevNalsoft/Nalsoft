import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/models/user_model.dart';
import 'package:meals_management_with_firebase/repositories/user_events_repo.dart';

class EmployeeLunchStatusProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<DateTime> _optedDates = [];
  List<DateTime> _notOptedDates = [];
  Map<DateTime, String> _notOptedDatesWithReasons = {};
  UserModel? user;

  Future<void> setUser({String? empid}) async {
    user = await _db.readDataWithID(empid: empid);
    notifyListeners();
  }

  Future<void> getOptedFromDB({String? empid}) async {
    _optedDates = await _db.readOptedWithID(empid: empid);
    notifyListeners();
  }

  Future<void> getNotOptedFromDB({String? empid}) async {
    _notOptedDates = await _db.readNotOptedWithID(empid: empid);
    notifyListeners();
  }

  Future<void> getNotOptedWithReasonsFromDB({String? empid}) async {
    _notOptedDatesWithReasons =
        await _db.readNotOptedWithReasonsWithID(empid: empid);
    notifyListeners();
  }

  UserModel? get getUser => user;
  List<DateTime> get getOpted => _optedDates;
  List<DateTime> get getNotOpted => _notOptedDates;
  Map<DateTime, String> get getNotOptedWithReasons => _notOptedDatesWithReasons;
}
