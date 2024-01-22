// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2/oauth2.dart' as oauth2;

// class GenerateNotificationProvider extends ChangeNotifier {
//   String? _title;
//   String _description = '';

//   sendNotification(title, description) async {
//   var serviceAccountJson = {
//   "type": "service_account",
//   "project_id": "meals-management-app-37e6a",
//   "private_key_id": "2c8d91205ec90065c37992cc1f321d966c91f80f",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/wSI9OYYUxIuE\ncMBBGyBpIceNfBRMc/hKq+9BHSc0yC3PM9EgfU9rdAGePkOQV3mjITKWwPA2JLN0\nZhmyCFHNFInU6yvRwE9HI8WVsPlo5OnGK1mpL6+ceTJagPMCvxhQN+ibxJGJsbZ0\nZuJRUovE7UWPsTXMVk4O5XPSKNzZdNUCYC/49IBCpm39odzRjEGgFV2bkT5ZNMoE\nIOEFe+XMdlmWl1ifAwxeY8sPCp0bkhdj2gTFcu2Rh9ZSIMiyK6Ht7H5Ccwexwxvo\nXsbKzqb7ozGWXY6xJEewyszBDvkrWYUuk7aHaoCERiNZpSNebxlckHnleQvYeG76\n1t+MwrWfAgMBAAECggEAEgdkzTswg0OxgcZ0xQpPDfjE7Dq7e9lhgb/QUx/HFRGH\nK8FJoH43ro4t2Bou5w4vxmneJEodVlyKr4nT+6cIQznISx0WCyFuMsLxwQUZMMa+\na3Py+P3IoJ534LDZaFYy69k92mYXxZ77B88Ok1UpWrQbrgrG2KClXoWDUhdRIHQk\n1BxCV/u60pbu7HQ3LWIYMZLyoxg0QGpiHjtsmHHb4q3hOurJcG66mteQGgD1sP7W\nlyyA+wkWTn/eHFLPTHSIjTRqqU1SP8F/cw9RT8mqm6AvGO4mfAd0GRzoFPSHN443\n4K5GGPp5Ys0dOYlkVUWaPv/KEYDW2OWqDBRd/KkLcQKBgQD7O/2Yr62/7Akd8Ig3\ngQ7O2uEfv0jJ+akQh8m0Div48viTZUZuYZi7SNmPgvCU77l0bMASti2MIWIFoxbM\nTDWjSVU21hXDDzasZ7zszOWSm8xsU6G/w1z9bwRpdnWhe1aCcqG5ZjbNZgo7QsRr\nusfXtRdG3kLN8G40lOY7emwVLwKBgQDDZE4XAnN71hvY/6d8TCMd9frvFJdrVsKX\nd/EaplHtLGY6buL7rh2raozU4leE2JKkR8XibgVdWyVW+TdF46NKPzS697s6t1F6\n5cWgx0yPH7wtwFEvEN+mzE2gR6UH1R88sfQ90f+QoyPQ0wAhr41S9DNdT1b3L2bb\nfzCSFL8qkQKBgEYt7NoxAOUixy0w2qw+hedspwRaR7f74Kk4dTSx3MCvBpcN7E27\nP5HZeMSo/BFuoayPEFxpvXFuhdYzR5QMGdOiEYa+6NdTMZ+ZXuH7HooEsWb1ObK6\nnQhCccYQDC3uqSzJXrnOfrKDtYn2Ta4WP+rWsEjgn2KtretMSMAGo5iLAoGAC2OR\nWa3+5Tz5qpBcRtZ5RYnM8pqUqOEJvqJzH0aKh/SKkOVdvaXMfO1dABuhVlD5WzID\nysr27RYe+w7TtfMq1W0RucQu2aFN0ogKGPEE+WK0KUaIdOHa53IJJEqIyAgYJgWJ\nYwEWkGux7r4dx9jft/Ib/FhfjVDqAelL/3fOHMECgYEAlNQBolL+OQe3M7fQgvAc\ninzbU6ZGU+7q1/0DmZexyBg15rJ3cOVxXdYW+aAmt3dg9yEiAHdGIq60KfSDLVey\n90FAK+B9icNnDn0ZP0r+CK4WsGijDSesvURtjBjR5FA6nwDEMDhfOcsmsX4faScj\nxhY+MylR4MasuOoB6iklHLE=\n-----END PRIVATE KEY-----\n",
//   "client_email": "firebase-adminsdk-xq23y@meals-management-app-37e6a.iam.gserviceaccount.com",
//   "client_id": "104219251059084849918",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xq23y%40meals-management-app-37e6a.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// };

// final clientId = serviceAccountJson['client_email'];
// final clientSecret = serviceAccountJson['private_key'];
// final scope = 'https://www.googleapis.com/auth/firebase.messaging';
// // final credentials = oauth2.clientCredentialsGrant(clientId as Uri, clientSecret,scope);
// final authorizationEndpoint = serviceAccountJson["auth_uri"];
// final tokenEndpoint =serviceAccountJson["token_uri"];
// final client_secret =serviceAccountJson["token_uri"];





// // var grant = oauth2.AuthorizationCodeGrant(
// //        FirebaseAuth.instance.currentUser!.uid,authorizationEndpoint as Uri, tokenEndpoint as Uri,
// //       secret: client_secret);

// //   var authorizationUrl = grant.getAuthorizationUrl("https://fcm.googleapis.com/v1/projects/meals-management-app-37e6a/messages:send" as Uri);




// // final token = credentials.getToken()
// // print('Access token: ${token.accessToken}');

// // Refresh token when close to expiry
// // token.whenExpired.listen((_) async {
// //   print('Refreshing access token...');
// //   await token.refresh();
// //   print('Refreshed access token: ${token.accessToken}');
// // });

//     _title = title;
//     _description = description.length == 0 ? "" : description;
//     final notificationPayload = {
//       // "to": "/topics/all-devices",
//       "notification": {
//         "title": "Lunch Notification !",
//         "body": "This is a new message  .",
//       },
//     };

//     try {
//       final url = Uri.parse(
//         "https://fcm.googleapis.com/v1/projects/meals-management-app-37e6a/messages:send",
//       );

//       final headers = {
//         "Authorization":
//             "bearer ya29.a0AfB_byCLBMKSLFWg4miOLxfamUezw08GADduNu89z4ZYQv2Mf_xKxqFOjNLmxuPFKKHxYh9lfPZveWqZfXzbqLk1ibwvys4-rEFIOLaU4vc_NulXhnzKY4pOjXolbInpKlQXrgJnsokiGrqo7PwMNjeLvDe7s_8-Wvi0aCgYKAe0SARESFQHGX2MicHRn7IT0DPci9n65Nk6oMg0171",
//         "Content-Type": "application/json",
//       };

//       final response = await http.post(
//         url,
//         headers: headers,
//         body: jsonEncode(notificationPayload),
//       );

//       if (response.statusCode == 200) {
//         print("Notification sent successfully!");
//       } else {
//         print("Error sending notification: ${response.body}");
//       }
//     } catch (e) {
//       print("Error sending notification: $e");
//     }
//   }

// }


import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

class GenerateNotificationProvider extends ChangeNotifier {
  String? _title;
  String _description = '';

  Future<void> sendNotification(String title, String description) async {
    // Replace with your actual service account credentials
    var serviceAccountJson = {
       "type": "service_account",
      "project_id": "meals-management-app-37e6a",
      "private_key_id": "2c8d91205ec90065c37992cc1f321d966c91f80f",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/wSI9OYYUxIuE\ncMBBGyBpIceNfBRMc/hKq+9BHSc0yC3PM9EgfU9rdAGePkOQV3mjITKWwPA2JLN0\nZhmyCFHNFInU6yvRwE9HI8WVsPlo5OnGK1mpL6+ceTJagPMCvxhQN+ibxJGJsbZ0\nZuJRUovE7UWPsTXMVk4O5XPSKNzZdNUCYC/49IBCpm39odzRjEGgFV2bkT5ZNMoE\nIOEFe+XMdlmWl1ifAwxeY8sPCp0bkhdj2gTFcu2Rh9ZSIMiyK6Ht7H5Ccwexwxvo\nXsbKzqb7ozGWXY6xJEewyszBDvkrWYUuk7aHaoCERiNZpSNebxlckHnleQvYeG76\n1t+MwrWfAgMBAAECggEAEgdkzTswg0OxgcZ0xQpPDfjE7Dq7e9lhgb/QUx/HFRGH\nK8FJoH43ro4t2Bou5w4vxmneJEodVlyKr4nT+6cIQznISx0WCyFuMsLxwQUZMMa+\na3Py+P3IoJ534LDZaFYy69k92mYXxZ77B88Ok1UpWrQbrgrG2KClXoWDUhdRIHQk\n1BxCV/u60pbu7HQ3LWIYMZLyoxg0QGpiHjtsmHHb4q3hOurJcG66mteQGgD1sP7W\nlyyA+wkWTn/eHFLPTHSIjTRqqU1SP8F/cw9RT8mqm6AvGO4mfAd0GRzoFPSHN443\n4K5GGPp5Ys0dOYlkVUWaPv/KEYDW2OWqDBRd/KkLcQKBgQD7O/2Yr62/7Akd8Ig3\ngQ7O2uEfv0jJ+akQh8m0Div48viTZUZuYZi7SNmPgvCU77l0bMASti2MIWIFoxbM\nTDWjSVU21hXDDzasZ7zszOWSm8xsU6G/w1z9bwRpdnWhe1aCcqG5ZjbNZgo7QsRr\nusfXtRdG3kLN8G40lOY7emwVLwKBgQDDZE4XAnN71hvY/6d8TCMd9frvFJdrVsKX\nd/EaplHtLGY6buL7rh2raozU4leE2JKkR8XibgVdWyVW+TdF46NKPzS697s6t1F6\n5cWgx0yPH7wtwFEvEN+mzE2gR6UH1R88sfQ90f+QoyPQ0wAhr41S9DNdT1b3L2bb\nfzCSFL8qkQKBgEYt7NoxAOUixy0w2qw+hedspwRaR7f74Kk4dTSx3MCvBpcN7E27\nP5HZeMSo/BFuoayPEFxpvXFuhdYzR5QMGdOiEYa+6NdTMZ+ZXuH7HooEsWb1ObK6\nnQhCccYQDC3uqSzJXrnOfrKDtYn2Ta4WP+rWsEjgn2KtretMSMAGo5iLAoGAC2OR\nWa3+5Tz5qpBcRtZ5RYnM8pqUqOEJvqJzH0aKh/SKkOVdvaXMfO1dABuhVlD5WzID\nysr27RYe+w7TtfMq1W0RucQu2aFN0ogKGPEE+WK0KUaIdOHa53IJJEqIyAgYJgWJ\nYwEWkGux7r4dx9jft/Ib/FhfjVDqAelL/3fOHMECgYEAlNQBolL+OQe3M7fQgvAc\ninzbU6ZGU+7q1/0DmZexyBg15rJ3cOVxXdYW+aAmt3dg9yEiAHdGIq60KfSDLVey\n90FAK+B9icNnDn0ZP0r+CK4WsGijDSesvURtjBjR5FA6nwDEMDhfOcsmsX4faScj\nxhY+MylR4MasuOoB6iklHLE=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-xq23y@meals-management-app-37e6a.iam.gserviceaccount.com",
      "client_id": "104219251059084849918",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xq23y%40meals-management-app-37e6a.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final authUri = serviceAccountJson['auth_uri'];
    final clientSecret = serviceAccountJson['private_key'];
    final scope = 'https://www.googleapis.com/auth/firebase.messaging';

    // Use clientCredentialsGrant to obtain an access token
    final credentials = await oauth2.clientCredentialsGrant(
      Uri.parse(authUri!),
      serviceAccountJson["client_email"],
      clientSecret,
      scopes: [scope],
    );

var cred=oauth2.Credentials.fromJson(serviceAccountJson as String);
print(cred.accessToken);
print("credentials ${credentials}");
    _title = title;
    _description = description.length == 0 ? "" : description;

    final notificationPayload = {
      "to": "/topics/mobiles",
      "notification": {
        "title": _title!,
        "body": _description,
      },
    };

    try {
      final url = Uri.parse(
          "https://fcm.googleapis.com/v1/projects/meals-management-app-37e6a/messages:send"
        
      );
      print("access token ${credentials.credentials.accessToken}");
      final headers = {
        "Authorization": "Bearer ${credentials.credentials.accessToken}",
        "Content-Type": "application/json",
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(notificationPayload),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully!");
      } else {
        print("Error sending notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
