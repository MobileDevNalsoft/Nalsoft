import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  final DioClient2? dioClient2;
  final SharedPreferences? sharedPreferences;

  UserRepo({this.dioClient2, this.sharedPreferences});

  Future<ApiResponse> getUserinfo(String username) async {
    try {
      String basicAuth = 'Basic ' +
          base64.encode(utf8.encode(
              '${AppConstants.APIUSERNAME}:${AppConstants.APIPASSWORD}'));
      Response response = await dioClient2!
          .get('${AppConstants.GETUSERINFO}?UserName=$username',
              options: Options(headers: {
                'Authorization': basicAuth,
              }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
