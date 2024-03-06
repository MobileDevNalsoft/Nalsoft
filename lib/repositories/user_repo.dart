import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/meals_management/api_response_model.dart';
import 'package:meals_management/utils/constants.dart';

class UserRepo {
  final DioClient2? dioClient2;

  UserRepo({this.dioClient2});

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

  Future<ApiResponse> getAllUserData(String date) async {
    try {
      String basicAuth = 'Basic ' +
          base64.encode(utf8.encode(
              '${AppConstants.APIUSERNAME}:${AppConstants.APIPASSWORD}'));
      Response response =
          await dioClient2!.get("${AppConstants.GETALLUSERSDATA}?Date=$date",
              options: Options(headers: {
                'Authorization': basicAuth,
              }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSearchData(String searchText) async {
    try {
      String basicAuth = 'Basic ' +
          base64.encode(utf8.encode(
              '${AppConstants.APIUSERNAME}:${AppConstants.APIPASSWORD}'));
      Response response = await dioClient2!
          .get("${AppConstants.SEARCH_DETAILS_API}?UserName=$searchText",
              options: Options(headers: {
                'Authorization': basicAuth,
              }));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
