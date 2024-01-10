import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/models/user_model.dart';
import 'package:meals_management_with_firebase/services/database_services.dart';

class HomePageProvider extends ChangeNotifier {
  final DatabaseServices _db = DatabaseServices();

  String _userName = 'Username';
  Map<String, dynamic> floorDetails = {'start_time': ' ', 'end_time': ' '};
  DateTime? _selectedDate;
  int _radioValue = 1;
  bool _reasonEmpty = false;
  String? _optionStatus;
  bool _isToggled = false;

  void setUserName() async {
    UserModel user = await _db.readData();
    _userName = user.userName;
    notifyListeners();
  }

  void setFloorDetails() async {
    UserModel user = await _db.readData();
    floorDetails = await _db.readFloorDetails(user.floor);
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

  String get getUserName => _userName;
  DateTime? get getSelectedDate => _selectedDate;
  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  String? get getOptions => _optionStatus;
  bool get getIsToggled => _isToggled;
  Map<String, dynamic> get getFloorDetails => floorDetails;
}
