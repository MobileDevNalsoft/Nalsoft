import 'package:cloud_firestore/cloud_firestore.dart';

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
}
