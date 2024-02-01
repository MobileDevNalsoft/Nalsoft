import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/repositories/user_events_repo.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/views/screens/emp_screens/home_view.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo? authRepo;

  AuthProvider({this.authRepo});

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  bool _isLoading = false;

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

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;

      String token = '';
      String token_type = '';

      try {
        token_type = map["token_type"];
      } catch (e) {}
      try {
        token = map["access_token"];
      } catch (e) {}

      if (token.isNotEmpty) {
        authRepo!.saveUserToken(token);
        print("token$token");
        notifyListeners();
      }
    }
  }

  Future authenticateUserName(
      String username, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    print('before auth');
    ApiResponse apiResponse =
        await authRepo!.authenticateUser(username, password);
    print('after auth');

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
        authRepo!.saveAuthToken(authToken);
        authRepo!.saveUserNameandPassword(username, password);
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
  bool get getIsLoading => _isLoading;
  String getUserToken() {
    return authRepo!.getUserToken();
  }

  String getAuthToken() {
    return authRepo!.getAuthToken();
  }
}
