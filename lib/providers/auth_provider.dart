import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/models/user_model.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserEventsRepo _db = UserEventsRepo();
  final AuthRepo? authRepo ;
  AuthenticationProvider({this.authRepo});


  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  String? _dept;
  String? _floor;
  List<dynamic> deptList = [];
  List<String> floorList = [];
  bool _isLoading = false;

  String? get getDept => _dept;
  String? get getFloor => _floor;
  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;
  List<dynamic> get getDeptList => deptList;
  List<String> get getFloorList => floorList;

  void setDept(String dept) {
    _dept = dept;
    notifyListeners();
  }

  void setFloor(String floor) {
    _floor = floor;
    notifyListeners();
  }

  void obscureToggle() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setErrTxt(int value) {
    _errTxt = value;
    notifyListeners();
  }

  void setPassErrTxt(int value) {
    _passErrTxt = value;
    notifyListeners();
  }


  Future getToken() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.gettoken();
    print(apiResponse.error);
    print(apiResponse.response);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = '';
      String token_type = '';
      try {
        token_type = map["token_type"];
      } catch (e) {print("error$e");};
      try {
        token = map["access_token"];
      } catch (e) {{print("error$e");}}
      print(token_type);
      print(token);
      if (token.isNotEmpty) {
        authRepo!.saveUserToken(token);
        print("token$token");
        getRequestState();
        notifyListeners();
      } else {}
    } else {
      print("api error  {$apiResponse.error}");
      notifyListeners();
    }
  }

 Future  getRequestState() async {
_isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.getRequestState();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
    String requestState = '';
       try {
        requestState = map["requestState"];
      } catch (e) {}
     
      if (requestState.isNotEmpty) {
        authRepo!.saveReqSate(requestState);
        print("req_state$requestState");
        notifyListeners();
      } else {
       
      }
    } 

  }


  Future<bool> authenticateUserName(
     String username, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.authenticateUser(username, password);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      String authToken = "";
      String status = "";

      try {
        authToken = map["authnToken"];
      } catch (e) {return false;}
      try {
        status = map["status"];
      } catch (e) {return false;}

      if (authToken.isNotEmpty && status == "success") {
        authRepo!.saveAuthToken(authToken);
        authRepo!.saveUserNameandPassword(username, password);
        print("token $authToken");
        _isLoading=false;
        notifyListeners();
        return true;
      }
    }
      return false;
  }

    String getAuthToken() {
    return authRepo!.getAuthToken();
  }
}
