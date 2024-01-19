import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class HomeStatusProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, Map<String, dynamic>>> _floorDetails = [];
  // int _radioValue = 1;
  // bool _reasonHomeEmpty = false;
  bool _reasonStatusEmpty = false;
  bool isWithinRadius = false;
  double officeLatitude = 17.4485391;
  double officeLongitude = 78.3823278;
  double radius = 100;
  String _selectedReason = 'Single day';

  // void setRadioValue(int? inValue) {
  //   _radioValue = inValue!;
  //   notifyListeners();
  // }

  // void setReasonHomeEmpty(bool value) {
  //   _reasonHomeEmpty = value;
  //   notifyListeners();
  // }

  void setReasonStatusEmpty(bool value) {
    _reasonStatusEmpty = value;
    notifyListeners();
  }

  void setReason(String value) {
    _selectedReason = value;
    notifyListeners();
  }

  // aquires details of floor from db
  Future<void> setFloorDetails() async {
    _floorDetails = await _db.readFloors();
    notifyListeners();
  }

  Future<void> checkRadius() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double distancefromOffice = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        officeLatitude,
        officeLongitude);
    print(
        "${currentPosition.longitude} ${currentPosition.latitude} $distancefromOffice");
    isWithinRadius = distancefromOffice <= radius;
  }

  // int get getRadioValue => _radioValue;
  // bool get getReasonHomeEmpty => _reasonHomeEmpty;
  bool get getReasonStatusEmpty => _reasonStatusEmpty;
  String get getReason => _selectedReason;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => _floorDetails;
}
