import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/repositories/auth_repo.dart';
import 'package:meals_management/views/screens/emp_screens/data_loader_page.dart';
import 'package:meals_management/views/screens/emp_screens/employee_home_view.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationRepo? authenticationRepo;
  AuthenticationProvider({this.authenticationRepo});

  bool _obscurePassword = true;
  int _errTxt = 0;
  int _passErrTxt = 0;
  String _reqState ="";
  String _authToken="";
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

  Future getToken(email,pass,context) async {
   print(email);
   print(pass);
   await authenticationRepo!.gettoken(email,pass,context);

   print("response");
  // _authToken=token;
        // getRequestState(token);
  
  }

  // Future getRequestState(String token) async {
  //  String reqState = await authenticationRepo!.getRequestState(token);
  // _reqState=reqState;
  //   // if (apiResponse.response != null &&
  //   //     apiResponse.response!.statusCode == 200) {
  //   //   Map map = apiResponse.response!.data;

  //   //   String requestState = '';

  //     // try {
  //     //   requestState = map["requestState"];
  //     // } catch (e) {}

  //     // if (requestState.isNotEmpty) {
  //     //   // authenticationRepo!.saveReqSate(requestState);
  //     //   print("req_state$requestState");
  //       notifyListeners();
  //     }
    
    
  

  // Future authenticateUserName(
  //     String username, String password, BuildContext context) async {
  //   ApiResponse apiResponse =
  //       await authenticationRepo!.authenticateUser(username, password);

  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     Map map = apiResponse.response!.data;

  //     String authToken = "";
  //     String status = "";
  //     try {
  //       authToken = map["authnToken"];
  //     } catch (e) {}
  //     try {
  //       status = map["status"];
  //     } catch (e) {}

  //     if (authToken.isNotEmpty && status == "success") {
  //       authenticationRepo!.saveAuthToken(_authToken);
  //       authenticationRepo!.saveUserNameandPassword(username, password);
  //       print("token $authToken");
  //       Provider.of<UserDataProvider>(context,listen:false).getUserinfo(username).then((value) =>  Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => DataLoader())));
       
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Login Successfull'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //       notifyListeners();
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'Something Went Wrong..',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'Something Went Wrong..',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

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
