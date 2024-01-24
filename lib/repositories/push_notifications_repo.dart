import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotitficationsRepo {
  final _db = FirebaseFirestore.instance;

  Future<String> getToken() async {
    DocumentSnapshot documentSnapshot =
        await _db.collection("dynamic").doc("access_token").get();
    return (documentSnapshot.data() as Map)["token"];
  }
}
