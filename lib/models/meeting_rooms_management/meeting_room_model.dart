import 'package:flutter/material.dart';
import 'package:meals_management/models/meeting_rooms_management/user_model.dart';

class GlobalMeetingRoomModel {
  String roomName;
  int floor;
  int size;
  List<BookingServices>? bookingsServicesList;

  GlobalMeetingRoomModel(
      {required this.roomName,
      required this.floor,
      required this.size,
      this.bookingsServicesList});
}

class BookingServices {
  MRUserModel user;
  DateTimeRange duration;
  BookingServices({required this.user, required this.duration});
}
