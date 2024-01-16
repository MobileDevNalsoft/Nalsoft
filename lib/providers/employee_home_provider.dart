import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meals_management/repositories/user_events_repo.dart';

class EmployeeHomeProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();

  List<Map<String, Map<String, dynamic>>> _floorDetails = [];
  int _radioValue = 1;
  bool _reasonEmpty = false;
  bool isWithinRadius = false;
  double officeLatitude = 17.4485391;
  double officeLongitude = 78.3823278;
  double radius = 100;

  void setRadioValue(int? inValue) {
    _radioValue = inValue!;
    notifyListeners();
  }

  void setReasonEmpty(bool value) {
    _reasonEmpty = value;
    notifyListeners();
  }

  // aquires details of floor from db
  Future<void> setFloorDetails() async {
    _floorDetails = await _db.readFloors();
    notifyListeners();
  }

  Future<void> checkRadius() async {
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

  int get getRadioValue => _radioValue;
  bool get getReasonEmpty => _reasonEmpty;
  List<Map<String, Map<String, dynamic>>> get getFloorDetails => _floorDetails;
}
