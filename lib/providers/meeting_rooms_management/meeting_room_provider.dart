import 'package:flutter/material.dart';
import 'package:meals_management/models/meeting_rooms_management/meeting_room_model.dart';
import 'package:meals_management/models/meeting_rooms_management/user_model.dart';

class MeetingRoomProvider extends ChangeNotifier {
  late DateTime _selectedStartTime;
  late DateTime _selectedEndTime;

  get selectedStartTime => _selectedStartTime;

  set selectedStartTime(value) {
    _selectedStartTime = value;
    notifyListeners();
  }

  get selectedEndTime => _selectedEndTime;

  set selectedEndTime(value) {
    _selectedEndTime = value;
    notifyListeners();
  }

  GlobalMeetingRoomModel meetingRoom = GlobalMeetingRoomModel(
      roomName: "Meeting room 8",
      floor: 8,
      size: 6,
      bookingsServicesList: [
        BookingServices(
            user: MRUserModel(userID: '1', username: "xyz"),
            duration: DateTimeRange(
                start: DateTime.now(),
                end: DateTime.now().add(Duration(hours: 1)))),
        BookingServices(
            user: MRUserModel(userID: '1', username: "xyz"),
            duration: DateTimeRange(
                start: DateTime.now().add(Duration(hours: 2)),
                end: DateTime.now().add(Duration(hours: 3)))),
      ]);

  void addFreeSlots() {
    DateTime startTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 9);
    DateTime endTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18);
    var freeSlots = [];

    DateTime previousBookingEnd = startTime;

    print("list ${meetingRoom.bookingsServicesList}");
    for (var booking in meetingRoom.bookingsServicesList!) {
      DateTimeRange currentBooking = booking.duration;

      // Calculate free slot between previous booking and current booking
      if (previousBookingEnd.isBefore(currentBooking.start) &&
          currentBooking.start.difference(previousBookingEnd).inMinutes > 1) {
        print("pre $previousBookingEnd curr ${currentBooking.start}");

        freeSlots.add(BookingServices(
            user: MRUserModel(username: '', userID: ''),
            duration: DateTimeRange(
                start: previousBookingEnd, end: currentBooking.start)));
      }
      // Update previous booking end time
      previousBookingEnd = currentBooking.end;
    }
    if (endTime.isAfter(previousBookingEnd)) {
      freeSlots.add(BookingServices(
          user: MRUserModel(username: '', userID: ''),
          duration: DateTimeRange(start: previousBookingEnd, end: endTime)));
    }

    for (var slots in freeSlots) {
      meetingRoom.bookingsServicesList!.add(slots);
    }

    meetingRoom.bookingsServicesList!
        .sort((a, b) => a.duration.start.compareTo(b.duration.start));
  }

  void bookSlot() {
    removeFreeSlots();
    print(
        "adding ${BookingServices(user: MRUserModel(username: 'abc', userID: '12'), duration: DateTimeRange(start: selectedStartTime, end: selectedEndTime)).duration.start}");
    meetingRoom.bookingsServicesList!.add(BookingServices(
        user: MRUserModel(username: 'abc', userID: '12'),
        duration:
            DateTimeRange(start: selectedStartTime, end: selectedEndTime)));
    meetingRoom.bookingsServicesList!.forEach(
      (element) => print("${element.duration.start} ${element.duration.end}"),
    );

    meetingRoom.bookingsServicesList!
        .sort((a, b) => a.duration.start.compareTo(b.duration.start));
    addFreeSlots();
    notifyListeners();
  }

  void removeFreeSlots() {
    List<BookingServices> meetingRoomList = [];
    meetingRoom.bookingsServicesList!.forEach((e) {
      if (e.user.username != "") {
        print("start ${e.duration.start}");
        meetingRoomList.add(e);
      }
    });
    print("room list${meetingRoomList}");

    meetingRoom.bookingsServicesList = meetingRoomList;
  }
}
