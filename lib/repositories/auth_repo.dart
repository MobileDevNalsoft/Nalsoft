import 'dart:convert';

import 'package:custom_widgets/src.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/providers/user_data_provider.dart';
import 'package:meals_management/route_management/route_management.dart';

import 'package:meals_management/utils/constants.dart';
import 'package:meals_management/views/screens/emp_screens/data_loader_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationRepo {
  final DioClient1? dioClient1;
  final SharedPreferences? sharedPreferences;
  AuthenticationRepo({this.dioClient1, this.sharedPreferences});

 Future authenticateUser(String username, String password, String token, String reqState,context) async {
  try {
    final Map<String, dynamic> requestData = {
      "op": "credSubmit",
      "credentials": {"username": username, "password": password},
      "requestState": reqState ?? ""
    };

    final response = await http.post(
      Uri.parse("https://idcs-7a99f7e141c2455daf8e203757d28727.identity.oraclecloud.com/${AppConstants.AUTHENCTICATE_USER_NAME}"),
      headers: {
        'Authorization': 'Bearer ${token ?? ""}',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestData),
    );
    print(response.body.toString());
     var resp = jsonDecode(response.body);
     print("authntoken${resp["authnToken"]}");
     if (resp["authnToken"]!=null){
      Provider.of<UserDataProvider>(context,listen:false).getUserinfo(username).then((value) =>  Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DataLoader())));
       
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successfull'),
            backgroundColor: Colors.green,
          ),
        );
     }
     else{
      CustomWidgets.CustomSnackBar(context, "Something went wrong", Colors.red);
     }
  } catch (e) {
    // Handle any exceptions
  }
}

  Future gettoken(String email,String pass,context) async {
  
    try {
      print('in repo get token');
      String username = 'c75d0cfcb0d44f6f83ab0923b6ee886b';
      String password = '8f3203a2-8c52-4b44-a8a0-03eb0c39f50c';
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$password'));

      final response = await http.post(Uri.parse('https://idcs-7a99f7e141c2455daf8e203757d28727.identity.oraclecloud.com/${AppConstants.GetOCITOKEN}'),
        body: {
            'grant_type': 'client_credentials',
            'scope': 'urn:opc:idm:__myscopes__',
          },
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded'
          });

          var resp = jsonDecode(response.body);
          print(resp["access_token"]);
          print("body ${response.body.toString()}");
          getRequestState(email,pass,resp["access_token"],context);
    } catch (e) {
      print(e.toString());
    }
  }

Future getRequestState(email,pass,String token,context) async {
  try {
    print('inside get request state');
    print("token inside get request $token");

    final response = await http.get(
      Uri.parse("https://idcs-7a99f7e141c2455daf8e203757d28727.identity.oraclecloud.com/${AppConstants.AUTHENCTICATE_USER_NAME}"),
      headers: {
        'Authorization': 'Bearer ${token ?? ""}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    print("req state in repo${response.body.toString()}");
 var resp = jsonDecode(response.body);
          print(resp["requestState"]); 
          authenticateUser(email, pass,token,resp["requestState"],context);
  } catch (e) {
    // Handle any exceptions
    return "";
  }
}
 saveUserToken(String token)  {
    try {
       sharedPreferences!.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  saveAuthToken(String token) {
    try {
     sharedPreferences!.setString(AppConstants.AUTHTOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  
saveUserNameandPassword(String username,String password)  {
   try {
       sharedPreferences!.setString(AppConstants.USERNAME, username);
       sharedPreferences!.setString(AppConstants.PASSWORD, password);
    } catch (e) {
      throw e;
    }
  }

  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.TOKEN) ?? "";
  }

  String getAuthToken() {
    return sharedPreferences!.getString(AppConstants.AUTHTOKEN) ?? "";
  }

  String getUsername() {
    return sharedPreferences!.getString(AppConstants.USERNAME) ?? "";
  }

  String getpassword() {
    return sharedPreferences!.getString(AppConstants.PASSWORD) ?? "";
  }
}
