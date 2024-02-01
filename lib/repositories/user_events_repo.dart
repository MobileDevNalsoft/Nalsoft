import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserEventsRepo {
  final _db = FirebaseFirestore.instance;
    final SharedPreferences? sharedPreferences;
      final DioClient2? dioClient;
   UserEventsRepo({this.dioClient,  this.sharedPreferences});

  Future<ApiResponse> getUserEventsData(int id ) async{

     try {
       String basicAuth =
      'Basic ' + base64.encode(utf8.encode('${Constants.USERNAME}:${Constants.PASSWORD}'));
      Response response = await dioClient!.get(
        '${Constants.GETUSEREVENTSDATA}?EmpID=00321',
       options: Options(
        headers: {
          'Authorization': basicAuth,      
        }
       )
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

}
}
