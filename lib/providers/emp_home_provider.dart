import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/services/database_service.dart';
import 'package:meals_management/views/models/user_model.dart';

class HomePageProvider extends ChangeNotifier {
  String _userName = '';
  bool _isAdmin=false;

  late DateTime _selectedDate;
  Map<String, dynamic> floorDetails = {'start_time': ' ', 'end_time': ' '};
  
  int _radioValue = 1;
  bool _reasonEmpty = false;
  String? _optionStatus;
  
  final DatebaseServices _db = DatebaseServices();

  get getFloorDetails => floorDetails;  
  get isAdmin => _isAdmin;

  void setFloorDetails() async {
    UserModel user = await _db.getEmployeeData(FirebaseAuth.instance.currentUser!.uid);
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

  String get getUserName => _userName;
  DateTime? get getSelectedDate => _selectedDate;
  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  String? get getOptions => _optionStatus;
}
