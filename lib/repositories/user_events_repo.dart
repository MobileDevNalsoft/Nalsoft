import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meals_management/APIClient/dio_client2.dart';
import 'package:meals_management/APIClient/exceptions/api_error_handler.dart';
import 'package:meals_management/models/api_response_model.dart';
import 'package:meals_management/models/user_events_model.dart';

import 'package:meals_management/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserEventsRepo {
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DioClient2? dioClient2;
  UserEventsRepo({this.dioClient2});

  Future<ApiResponse> getUserEventsData(String empid) async{
     try {
       String basicAuth =
      'Basic ' + base64.encode(utf8.encode('${AppConstants.APIUSERNAME}:${AppConstants.APIPASSWORD}'));
      Response response = await dioClient2!.get(
        '${AppConstants.GETUSEREVENTSDATA}?EmpID=$empid',
       options: Options(
        headers: {
          'Authorization': basicAuth,      
        }
       )
      );
      print(response);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e);
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateUserEvents(String empid, List<Map<String, dynamic>> dates) async {
    var data;
    try{
      var num = int.parse(dates.first['info']);
      data = {
            "data": {
                "opted_dates": dates,
                "not_opted": []
            }
        };
    } catch(e){
      data = {
            "data": {
                "opted_dates": [],
                "not_opted": dates
            }
        };
    }
    
    try {
       String basicAuth =
      'Basic ' + base64.encode(utf8.encode('${AppConstants.APIUSERNAME}:${AppConstants.APIPASSWORD}'));
      Response response = await dioClient2!.post(
        '${AppConstants.UPDATEUSEREVENTS}?EmpID=$empid',
        data: data,
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
