import 'package:custom_widgets/src.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/models/meals_management/api_response_model.dart';
import 'package:meals_management/providers/meals_management/user_data_provider.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/route_management/route_management.dart';
import 'package:meals_management/views/app_navigation.dart';
import 'package:meals_management/views/screens/meals_management/emp_screens/data_loader_page.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationRepo? authenticationRepo;
  AuthenticationProvider({this.authenticationRepo});

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  bool loginLoader = false;

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
        Provider.of<UserDataProvider>(context, listen: false)
            .getUserinfo(username)
            .then((value) {
          if (Provider.of<UserDataProvider>(context, listen: false)
                  .getUserData
                  .data!
                  .userName !=
              "") {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    AppNavigation(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successfull'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            CustomWidgets.CustomSnackBar(context, "No Data Found", Colors.red);
          }
        });

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
    loginLoader = false;
    notifyListeners();
  }

  bool get obscurePassword => _obscurePassword;
  int get getErrTxt => _errTxt;
  int get getPassErrTxt => _passErrTxt;

  String getUserToken() {
    return authenticationRepo!.getUserToken();
  }

  String getAuthToken() {
    return authenticationRepo!.getAuthToken();
  }
}
