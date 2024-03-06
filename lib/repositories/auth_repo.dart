import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:meals_management/APIClient/dio_client1.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/meals_management/api_response_model.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepo {
  final DioClient1? dioClient1;
  final SharedPreferences? sharedPreferences;
  AuthenticationRepo({this.dioClient1, this.sharedPreferences});

  Future<ApiResponse> authenticateUser(String username, String password) async {
    try {
      print('before response');
      print(sharedPreferences!.getString(AppConstants.TOKEN));
      print(sharedPreferences!.getString(AppConstants.REQ_STATE));

      Response response =
          await dioClient1!.post(AppConstants.AUTHENCTICATE_USER_NAME,
              data: {
                "op": "credSubmit",
                "credentials": {"username": username, "password": password},
                "requestState":
                    sharedPreferences!.getString(AppConstants.REQ_STATE) ?? ""
              },
              options: Options(headers: {
                'Authorization':
                    'Bearer ${sharedPreferences!.getString(AppConstants.TOKEN) ?? ""}',
                'Content-Type': 'application/json'
              }));
      print('after response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);

      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> gettoken() async {
    try {
      String username = 'a07dc2a022db4c458397118abb543e57';
      String password = 'bf06245f-33ae-4b6c-9d0e-27fc0d89f514';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));

      Response response = await dioClient1!.post('${AppConstants.GetOCITOKEN}',
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
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getRequestState() async {
    try {
      Response response =
          await dioClient1!.get(AppConstants.AUTHENCTICATE_USER_NAME,
              options: Options(headers: {
                'Authorization':
                    'Bearer ${sharedPreferences!.getString(AppConstants.TOKEN) ?? ""}',
                'Content-Type': 'application/x-www-form-urlencoded'
              }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<void> saveUserToken(String token) async {
    try {
      await sharedPreferences!.setString(AppConstants.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveAuthToken(String token) async {
    try {
      await sharedPreferences!.setString(AppConstants.AUTHTOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveUserNameandPassword(String username, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.USERNAME, username);
      await sharedPreferences!.setString(AppConstants.PASSWORD, password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> saveReqSate(String req_state) async {
    try {
      await sharedPreferences!.setString(AppConstants.REQ_STATE, req_state);
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
