
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/repositories/user_events_repo.dart';

class EventsProvider extends ChangeNotifier{

  final UserEventsRepo _db = UserEventsRepo();

  List<DateTime> _optedDates = [];
  List<DateTime> _notOptedDates = [];
  Map<DateTime,String> _notOptedDatesWithReasons = {};

  Future<void> getOptedFromDB() async {
    _optedDates = await _db.readOpted();
    notifyListeners();
  }

  Future<void> getNotOptedFromDB() async {
    _notOptedDates = await _db.readNotOpted();
    notifyListeners();
  }

  Future<void> getNotOptedWithReasonsFromDB() async{
    _notOptedDatesWithReasons = await _db.readNotOptedWithReasons();
    notifyListeners();
  }

  List<DateTime> get getOpted => _optedDates;
  List<DateTime> get getNotOpted => _notOptedDates;
  Map<DateTime,String> get getNotOptedWithReasons => _notOptedDatesWithReasons;

  // pushes date to db to opted or notOpted category
  Future<void> pushDate({required DateTime date, required int radioValue, String? reason}) async {
    _db.pushDatetoDB(date: date, radioValue: radioValue, reason: reason);
  }

  // pushes dates to db to notopted category
  Future<void> pushDates({required List<DateTime> dates, required int radioValue, String? reason}) async {
    _db.pushDatestoDB(dates: dates, radioValue: radioValue, reason: reason);
  }
}