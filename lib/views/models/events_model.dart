
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsModel {
  List<DateTime>? opted;
  List<DateTime>? notOpted;
  List<DateTime>? unSigned;

  EventsModel({this.opted, this.notOpted, this.unSigned});

  EventsModel.fromJson(Map<String, dynamic> json) {
    // print(json);
    opted = (json['opted'] as List<dynamic>?)
            ?.map((dynamic timestamp) => (timestamp as Timestamp).toDate())
            .toList() ??
        [];
    print("added op");
    notOpted = (json['notOpted'] as List<dynamic>?)
            ?.map((dynamic timestamp) => (timestamp as Timestamp).toDate())
            .toList() ??
        [];
    unSigned = (json['unSigned'] as List<dynamic>?)
            ?.map((dynamic timestamp) => (timestamp as Timestamp).toDate())
            .toList() ??
        [];
  }
  Map<String, dynamic> toJson(user) {
    print("dates");
    print(opted);
    print(notOpted);
    print(unSigned);
    return {
      'opted': opted!.map((date) => Timestamp.fromDate(date)).toList(),
      // 'notOpted': dates!.map((date) => Timestamp.fromDate(date)).toList(),
      'unSigned': unSigned!.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = {};
  //   if (opted != null) {
  //     data['opted'] =
  //         opted!.map((DateTime date) => date.toIso8601String()).toList();
  //   }
  //   if (notOpted != null) {
  //     data['notOpted'] =
  //         notOpted!.map((DateTime date) => date.toIso8601String()).toList();
  //   }
  //   if (unSigned != null) {
  //     data['unSigned'] =
  //         unSigned!.map((DateTime date) => date.toIso8601String()).toList();
  //   }
  //   return data;
  // }
}
