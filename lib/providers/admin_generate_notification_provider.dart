import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals_management/repositories/push_notifications_repo.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class GenerateNotificationProvider extends ChangeNotifier {
  PushNotitficationsRepo notificationRepo = PushNotitficationsRepo();

  String? _title;
  String _description = '';
  bool isLoading = false;

  Future<bool> sendNotification(String title, String description) async {
    isLoading=true;
    notifyListeners();
    _title = title;
    _description = description.length == 0 ? "" : description;

    final notificationPayload = {
      "message": {
        "topic": "mobiles",
        "notification": {"title": _title, "body": _description},
      }
    };

    String accessToken = await notificationRepo.getToken();

    try {
      final url = Uri.parse(
          "https://fcm.googleapis.com/v1/projects/meals-management-app-37e6a/messages:send");
      final headers = {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(notificationPayload),
      );
      
      if (response.statusCode == 200) {
        print("Notification sent successfully!");
        isLoading=false;
        notifyListeners();
        return true;
      } else {
        print("Error sending notification: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending notification: $e");
      return false;
    }
  }
}
