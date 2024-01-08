
import 'package:flutter/material.dart';

class StatusProvider extends ChangeNotifier{

  String _selectedReason = 'Single day leave';

  void setReason(String value){
    _selectedReason = value;
    notifyListeners();
  }

  get getReason => _selectedReason;
}