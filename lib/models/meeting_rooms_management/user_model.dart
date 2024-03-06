import 'package:flutter/material.dart';

class MRUserModel {
  String username;
  String userID;
  List<SpecificMeetingRoomModel>? myBookings;
  MRUserModel({required this.username, required this.userID, this.myBookings});
}

class SpecificMeetingRoomModel {
  String roomName;
  int floor;
  int size;
  DateTimeRange duration;

  SpecificMeetingRoomModel(
      {required this.roomName,
      required this.floor,
      required this.size,
      required this.duration});
}
