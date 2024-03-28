import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:meals_management/APIClient/dio_client2.dart';

class FirebaseRepo {
  final DioClient2? dioClient2;

  FirebaseRepo({this.dioClient2});

  final _db = FirebaseFirestore.instance;

  Future<String> getToken() async {
    print("get token");
    try {
//method 1: get auth token from firebase

      // DocumentSnapshot documentSnapshot =
      //     await _db.collection("dynamic").doc("access_token").get();
      // print("inside notification repo$documentSnapshot");
      // return (documentSnapshot.data() as Map)["token"];

//method 2: get auth token from server

      Response response =
          await dioClient2!.get("https://nalsoft-server-3.onrender.com");
      print(response);
      print(response.data);
      return json.decode(response.toString())['access_token'];
    } catch (e) {
      print(e);
      return getToken();
    }
  }

  Future<bool> saveNotification(String title, String description) async {
    try {
      await _db
          .collection("notifications")
          .doc(DateTime.now().toString().substring(0, 10))
          .set({
        "message": FieldValue.arrayUnion([
          {
            "title": title,
            "description": description,
            "time": DateTime.now().millisecondsSinceEpoch
          }
        ])
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<Map<String, dynamic>> getNotifications() async {
  //   try {
  //     DocumentSnapshot documentSnapshot = await _db
  //         .collection("notifications")
  //         .doc(DateTime.now().toString().substring(0, 10))
  //         .get();
  //     print(DateTime.now().toString().substring(0, 10));
  //     print(documentSnapshot.data() as Map<String, dynamic>);
  //     return (documentSnapshot.data() as Map<String, dynamic>);
  //   } catch (e) {
  //     print(e);
  //     return {};
  //   }
  // }
}
