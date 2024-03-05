import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseRepo {
  final _db = FirebaseFirestore.instance;

  Future<String> getToken() async {
    print("get token");
    try {
      DocumentSnapshot documentSnapshot =
          await _db.collection("dynamic").doc("access_token").get();
      print("inside notification repo$documentSnapshot");
      return (documentSnapshot.data() as Map)["token"];
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<bool> saveNotification(String title, String description) async {
    try {
      await _db
          .collection("notifications")
          .doc(DateTime.now().toString().substring(0, 10))
          .update({
        "message": FieldValue.arrayUnion([
          {"title": title, "description": description}
        ])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, String>>> getNotifications() async {
    try {
      DocumentSnapshot documentSnapshot = await _db
          .collection("notifications")
          .doc(DateTime.now().toString().substring(0, 11))
          .get();
      return (documentSnapshot.data() as List<Map<String, String>>);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
