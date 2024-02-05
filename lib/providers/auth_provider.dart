import 'package:flutter/material.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationRepo? authenticationRepo ;
  AuthenticationProvider({this.authenticationRepo});

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;

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
    notifyListeners();
    ApiResponse apiResponse = await authenticationRepo!.gettoken();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      String token = '';

      try {
        token = map["access_token"];
      } catch (e) {}

      if (token.isNotEmpty) {
        authenticationRepo!.saveUserToken(token);
        print("token$token");
        getRequestState();
        notifyListeners();
      }
    }
  }

  Future getRequestState() async {
    ApiResponse apiResponse = await authenticationRepo!.getRequestState();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      String requestState = '';

      try {
        requestState = map["requestState"];
      } catch (e) {}

      if (requestState.isNotEmpty) {
        authenticationRepo!.saveReqSate(requestState);
        print("req_state$requestState");
        notifyListeners();
      }
    }
  }

  Future authenticateUserName(
      String username, String password, BuildContext context) async {
    ApiResponse apiResponse =
        await authenticationRepo!.authenticateUser(username, password);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      String authToken = "";
      String status = "";
      try {
        authToken = map["authnToken"];
      } catch (e) {}
      try {
        status = map["status"];
      } catch (e) {}

      if (authToken.isNotEmpty && status == "success") {
        authenticationRepo!.saveAuthToken(authToken);
        authenticationRepo!.saveUserNameandPassword(username, password);
        print("token $authToken");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EmployeeHomeView()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successfull'),
            backgroundColor: Colors.green,
          ),
        );
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something Went Wrong..',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something Went Wrong..',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;
  String get getUserToken => authenticationRepo!.getUserToken();
  String get getAuthToken => authenticationRepo!.getAuthToken();
}
