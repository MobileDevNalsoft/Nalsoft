
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{

  String _userName;
  String _email;
  String _employee_id;
  String _password;
  String _department;
  String _floor;
  bool _isAdmin = false;
  UserEvents _events;

  UserModel(
    this._userName,
    this._email,
    this._employee_id,
    this._password,
    this._department,
    this._floor,
    this._isAdmin,
    this._events
  );

  static UserModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    return UserModel(
      snapshot['userName'],
      snapshot['email'],
      snapshot['employee_id'],
      snapshot['password'],
      snapshot['department'],
      snapshot['floor'],
      snapshot['isAdmin'],
      snapshot['events'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username' : _userName,
      'email': _email,
      'employee_id': _employee_id,
      'password': _password,
      'department': _department,
      'floor': _floor,
      'isAdmin' : _isAdmin,
      'events' : _events,
    };
  }

}

class UserEvents{
  List<DateTime> optedDates = [];
  List<DateTime> notOptedDates = [];
  List<DateTime> unSignedDates = [];
}