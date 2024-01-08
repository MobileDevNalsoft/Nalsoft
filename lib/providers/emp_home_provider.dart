
import 'package:flutter/material.dart';

class HomePageModel extends ChangeNotifier{
  String _userName = 'Username';
  DateTime? _selectedDate;
  int _radioValue = 1;
  bool _reasonEmpty = false;
  String? _optionStatus;

  void setSelectedDate(DateTime date){
    _selectedDate = date;
    notifyListeners();
  }

  void setRadioValue(int? inValue){
    _radioValue = inValue!;
    notifyListeners();
  }

  void setReasonEmpty(bool value){
    _reasonEmpty = value;
    notifyListeners();
  }

  void setOptions(String value){
    _optionStatus = value;
    notifyListeners();
  }

  String get getUserName => _userName;
  DateTime? get getSelectedDate => _selectedDate;
  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  String?get getOptions => _optionStatus;

}