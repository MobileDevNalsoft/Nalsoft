import 'package:flutter/material.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_events_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/repositories/user_repo.dart';

class UserDataProvider extends ChangeNotifier {
  final UserEventsRepo? userEventsRepo;
  final UserRepo? userRepo;

  UserDataProvider({this.userRepo, this.userEventsRepo});

  // for UI updations related to user data
  UserModel? _user;
  List<dynamic> _optedDates = [];
  List<Dates> _notOptedDates = [];
  List<dynamic> _holidays = [];
  UserEventsModel? _userEventsModel;


  // getters
  List<dynamic> get holidays => _holidays;

  UserModel get getUserData => _user!;
  List<dynamic> get getOpted => _optedDates;
  List<Dates> get getNotOpted => _notOptedDates;

  // getting user data from firestore collection
  Future<void> getUserinfo(String? username) async {
    String username = "raviteja.singamsetty@nalsoft.net";
    ApiResponse apiResponse = await userRepo!.getUserinfo(username);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _user = UserModel.fromJson(apiResponse.response!.data);
    }
    notifyListeners();
  }

  Future<void> updateUserEvents(List<Map<String, dynamic>> dates, bool isOpted) async {
    isOpted?_optedDates.add(dates.map((e) => e.keys).toList()):dates.forEach((element) {_notOptedDates.add(Dates.fromJson(element));});
    ApiResponse apiResponse = await userEventsRepo!.updateUserEvents(_user!.data!.empId!, dates,isOpted);
    print(apiResponse);
    notifyListeners();
  }

  void setOptedDates({DateTime? date}) {
    if (date == null) {
      // _optedDates = _user!.opted;
      notifyListeners();
      // we will get this from the model after API method 1 is a success
    } else {
      _optedDates.add(date.toString().substring(0, 10));
      notifyListeners();
    }
  }


  Future<void> getHolidays() async {
      ApiResponse apiResponse =
        await userEventsRepo!.getHolidays();
         if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
        print("holidays${apiResponse.response!.data}");
          _holidays=apiResponse.response!.data["dates"].map((date)=>date["date"]).toList();
          print(_holidays);
          notifyListeners();
        }
  }

Future<void> getUserEventsData() async {
    ApiResponse apiResponse =
        await userEventsRepo!.getUserEventsData(_user!.data!.empId!);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _userEventsModel = UserEventsModel.fromJson(apiResponse.response!.data);
      _optedDates =_userEventsModel!.data!.optedDates!.map((date) => date.date).toList();
      _notOptedDates = _userEventsModel!.data!.notOpted!;
      print(_optedDates);
      print(_userEventsModel!.data!.notOpted!);
      notifyListeners();
    }
  }

Future<void> deleteUserEvents(List dates) async {
    dates.forEach((element) {
    print(element);
    _notOptedDates.removeWhere((date) => date.date==element["date"]);
    });
    print(_notOptedDates);
    ApiResponse apiResponse =
        await userEventsRepo!.deleteUserEvents(_user!.data!.empId!,dates);
    print(apiResponse.response!.data);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
          print(apiResponse.response!.data); 
      notifyListeners();
    }
    }
  }



