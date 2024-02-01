import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_model.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DioClient1 dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepo({required this.dioClient, this.sharedPreferences});

  Future<ApiResponse> authenticateUser(String username, String password) async {
    try {
      Response response =
          await dioClient!.post(Constants.AUTHENCTICATE_USER_NAME,
              data: {
                "op": "credSubmit",
                "credentials": {"username": username, "password": password},
                "requestState":
                    sharedPreferences!.getString(Constants.REQ_STATE) ?? ""
              },
              options: Options(headers: {
                'Authorization':
                    'Bearer ${sharedPreferences!.getString(Constants.TOKEN) ?? ""}',
                'Content-Type': 'application/json'
              }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> gettoken() async {
    try {
      String username = 'c75d0cfcb0d44f6f83ab0923b6ee886b';
      String password = '8f3203a2-8c52-4b44-a8a0-03eb0c39f50c';
      String basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));

      Response response = await dioClient.post('${Constants.GetOCITOKEN}',
          data: {
            'grant_type': 'client_credentials',
            'scope': 'urn:opc:idm:__myscopes__',
          },
          options: Options(headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded'
          }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print("error$e");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

Future<ApiResponse> getRequestState() async{
try {
      Response response = await dioClient!.get(
        Constants.AUTHENCTICATE_USER_NAME,
       options: Options(
        headers: {
          'Authorization': 'Bearer ${sharedPreferences!.getString(Constants.TOKEN) ?? ""}',
      'Content-Type':'application/x-www-form-urlencoded' 
        }
       )
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
}

  Future<void> saveUserToken(String token) async {
    try {
      await sharedPreferences!.setString(Constants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

    Future<void> saveAuthToken(String token) async {
    try {
      await sharedPreferences!.setString(Constants.AUTHTOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  
 Future<void> saveUserNameandPassword(String username,String password) async {
   try {
      await sharedPreferences!.setString(Constants.USERNAME, username);
      await sharedPreferences!.setString(Constants.PASSWORD, password);
    } catch (e) {
      throw e;
    }
  }

    Future<void> saveReqSate(String req_state) async {
    try {
      await sharedPreferences!.setString(Constants.REQ_STATE, req_state);
    } catch (e) {
      throw e;
    }
  }
   String getAuthToken() {
    return sharedPreferences!.getString(Constants.AUTHTOKEN) ?? "";
  }
}
