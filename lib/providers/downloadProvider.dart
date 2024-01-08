import 'package:flutter/material.dart';

class DownloadProvider extends ChangeNotifier{
  String _startDate='';
  String _endDate='';

  String get startDate=>_startDate;
  String get endDate=>_endDate;

  void updateDateRange({String startDate='',String endDate=''}){
    _startDate=startDate;
    _endDate=endDate;
    notifyListeners();
  }
}