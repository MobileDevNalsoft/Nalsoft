import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/services/database_service.dart';
import 'package:meals_management/views/models/user_model.dart';
import 'package:geolocator/geolocator.dart';

class HomePageProvider extends ChangeNotifier {
  String _userName = '';
  bool _isAdmin = false;

  late DateTime _selectedDate;
  Map<String, dynamic> floorDetails = {'start_time': ' ', 'end_time': ' '};

  int _radioValue = 1;
  bool _reasonEmpty = false;
  String? _optionStatus;
  bool isWithinRadius = false;
  double officeLatitude = 37.4219983;
  double officeLongitude = -122.084;
  double radius = 100;
  
  final DatebaseServices _db = DatebaseServices();

  get getFloorDetails => floorDetails;
  get isAdmin => _isAdmin;

  void setFloorDetails() async {
    UserModel user =
        await _db.getEmployeeData(FirebaseAuth.instance.currentUser!.uid);
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

  void checkRadius() async {
    // await Geolocator.requestPermission();
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("location denied");
        return Future.error('Location permissions are denied');
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(" location ${currentPosition.latitude} ${currentPosition.longitude}");

    double distancefromOffice = await Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        officeLatitude,
        officeLongitude);

    print(distancefromOffice);
    isWithinRadius = distancefromOffice <= radius;
  }
}
