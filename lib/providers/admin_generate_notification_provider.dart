import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals_management/repositories/push_notifications_repo.dart';

class GenerateNotificationProvider extends ChangeNotifier {
  PushNotitficationsRepo notificationRepo = PushNotitficationsRepo();

  String? _title;
  String _description = '';
  bool isLoading = false;

  Future<bool> sendNotification(String title, String description) async {
    isLoading=true;
    notifyListeners();
    print("isLoading$isLoading");
    _title = title;
    _description = description.length == 0 ? "" : description;

    final notificationPayload = {
      "message": {
        "topic": "mobiles",
        "notification": {"title": _title, "body": _description},
      }
    };

    String accessToken = await notificationRepo.getToken();
     print(accessToken);
     if( accessToken==''){
     isLoading=false;
        notifyListeners();
      return false;
     }
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
      print("response status code${response.statusCode}");
      if (response.statusCode == 200) {
        print("Notification sent successfully!");
        isLoading=false;
        notifyListeners();
        return true;
      } else {
        isLoading=false;
        notifyListeners();
        print("Error sending notification: ${response.body}");
        return false;
      }
    } catch (e) {
       isLoading=false;
        notifyListeners();
      print("Error sending notification: $e");
      return false;
    }
  }
}
