import 'package:flutter/material.dart';
import 'package:meals_management/models/meeting_rooms_management/meeting_room_model.dart';
import 'package:meals_management/models/meeting_rooms_management/user_model.dart';

class HomeViewProvider extends ChangeNotifier {
  List<GlobalMeetingRoomModel> _roomsList = [
    GlobalMeetingRoomModel(
        roomName: 'Meeting Room 1',
        floor: 8,
        size: 4,
        bookingsServicesList: [
          BookingServices(
              user: MRUserModel(username: 'Madhan', userID: '00633'),
              duration: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(Duration(hours: 1)))),
          BookingServices(
              user: MRUserModel(username: 'Madhan', userID: '00633'),
              duration: DateTimeRange(
                  start: DateTime.now().add(Duration(hours: 1)),
                  end: DateTime.now().add(Duration(hours: 2))))
        ]),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 2',
      floor: 8,
      size: 5,
    ),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 4',
      floor: 8,
      size: 4,
    ),
    GlobalMeetingRoomModel(
        roomName: 'Meeting Room 5',
        floor: 8,
        size: 8,
        bookingsServicesList: [
          BookingServices(
              user: MRUserModel(username: 'Madhan', userID: '00633'),
              duration: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(Duration(hours: 1))))
        ]),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 6',
      floor: 8,
      size: 4,
    ),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 7',
      floor: 8,
      size: 5,
    ),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 8',
      floor: 8,
      size: 4,
    ),
    GlobalMeetingRoomModel(
        roomName: 'Meeting Room 1',
        floor: 1,
        size: 5,
        bookingsServicesList: [
          BookingServices(
              user: MRUserModel(username: 'Madhan', userID: '00633'),
              duration: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(Duration(hours: 1))))
        ]),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 2',
      floor: 1,
      size: 4,
    ),
    GlobalMeetingRoomModel(
        roomName: 'Meeting Room 3',
        floor: 1,
        size: 8,
        bookingsServicesList: [
          BookingServices(
              user: MRUserModel(username: 'Madhan', userID: '00633'),
              duration: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(Duration(hours: 1))))
        ]),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 4',
      floor: 1,
      size: 4,
    ),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 1',
      floor: 9,
      size: 4,
    ),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 2',
      floor: 9,
      size: 5,
    ),
    GlobalMeetingRoomModel(
        roomName: 'Meeting Room 3',
        floor: 9,
        size: 8,
        bookingsServicesList: [
          BookingServices(
              user: MRUserModel(username: 'Madhan', userID: '00633'),
              duration: DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(Duration(hours: 1))))
        ]),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 4',
      floor: 9,
      size: 4,
    ),
    GlobalMeetingRoomModel(
      roomName: 'Meeting Room 5',
      floor: 9,
      size: 8,
    ),
  ];

  MRUserModel? _user;
  int _currentPage = 0;
  int _currentFloorPage = 0;
  int _checkAvailabilityCurrentFloorPage = 0;

  DateTime _currentDate = DateTime.now();

  get currentDate => _currentDate;

  set currentDate(value) {
    _currentDate = value;
    notifyListeners();
  }

  set setRoomsList(list) {
    _roomsList = [];
    notifyListeners();
  }

  set setCurrentPage(value) {
    _currentPage = value;
    notifyListeners();
  }

  set setCurrentFloorPage(value) {
    _currentFloorPage = value;
    notifyListeners();
  }

  set setCheckAvailabilityCurrentFloorPage(value) {
    _checkAvailabilityCurrentFloorPage = value;
    notifyListeners();
  }

  set setUser(user) {
    _user = user;
  }

  void deleteBooking(
      String roomName, int floor, DateTimeRange duration, String userID) {
    _user!.myBookings!.removeWhere((element) =>
        roomName == element.roomName &&
        floor == element.floor &&
        duration == element.duration);

    _roomsList
        .firstWhere(
          (element) {
            return (roomName == element.roomName && floor == element.floor);
          },
        )
        .bookingsServicesList!
        .removeWhere(
          (element) =>
              userID == element.user.userID &&
              duration.toString().substring(0, 16) ==
                  element.duration.toString().substring(0, 16),
        );

    notifyListeners();
  }

  List<GlobalMeetingRoomModel> get getRoomsList => _roomsList;
  int get getCurrentPage => _currentPage;
  int get getCurrentFloorPage => _currentFloorPage;
  int get getCheckAvailabilityCurrentFloorPage =>
      _checkAvailabilityCurrentFloorPage;
  MRUserModel get getUser => _user!;
}
