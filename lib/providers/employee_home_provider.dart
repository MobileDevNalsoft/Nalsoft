import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class EmployeeHomeProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  List<Map<String, Map<String, dynamic>>> floorDetails = [];
  DateTime? _selectedDate;
  int _radioValue = 1;
  bool _reasonEmpty = false;
  String? _optionStatus;
  bool _isToggled = false;
  List<DateTime>? optedDates = [];

  Future<void> setFloorDetails() async {
    floorDetails = await _db.readFloors();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setRadioValue(int? inValue) {
    _radioValue = inValue!;
    notifyListeners();
  }

  void setReasonEmpty(bool value) {
    _reasonEmpty = value;
    notifyListeners();
  }

  void setOptions(String value) {
    _optionStatus = value;
    notifyListeners();
  }

  void setIsToggled(bool value) {
    _isToggled = value;
    notifyListeners();
  }

  void setOptedDate(DateTime date) {
    optedDates!.add(date);
    _db.pushEvents(optedDates);
  }

  void setNotOptedDate(DateTime date) {
    optedDates!.add(date);
    _db.pushEvents(optedDates);
  }

  // void pushEvents(EventsModel events){
  //   _db.pushEventDates(events);
  // }

  DateTime? get getSelectedDate => _selectedDate;
  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  String? get getOptions => _optionStatus;
  bool get getIsToggled => _isToggled;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => floorDetails;
}
