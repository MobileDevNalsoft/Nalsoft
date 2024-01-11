import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class SignatureRepo {
  

  // Future<bool> uploadImageToDb(Uint8List imageBytes, String uid,String imageName) async {
  //   try {
  //     final ref =FirebaseStorage.instanceFor(bucket: "gs://meals-management-app-37e6a.appspot.com").ref().child("signatures/$uid/$imageName");
  //     return await ref.putData(imageBytes).then((p0) =>  true);
  //   } catch (e) {
  //     print("error occurred ${e}");
  //     return false;
  //   }
  // }
  Future<String> uploadImageToDb(Uint8List imageBytes, String uid, String imageName) async {
  try {
    final ref = FirebaseStorage.instanceFor(app:FirebaseAuth.instance.app,bucket: "gs://meals-management-app-37e6a.appspot.com").ref().child("signatures/$uid/$imageName");
    final uploadTask = ref.putData(imageBytes);

    await uploadTask; // Ensure completion before proceeding
    print("upload done");
    final downloadUrl = await ref.getDownloadURL();
    return downloadUrl; // Return the download URL directly
  } catch (e) {
    print("Upload error: $e");
    throw e; // Re-throw the error for proper handling in calling code
  }
}


Future<String> getSignatureFromDb(String uid, String imageName) async {
  try {
    final ref = FirebaseStorage.instanceFor(bucket: "/b/meals-management-app-37e6a.appspot.com/o").ref().child("signatures/$uid/$imageName");
    return await ref.getDownloadURL();
  } catch (e) {
    print("Download error: $e");
    rethrow; // Re-throw the error for appropriate handling
  }
}


//    getSignatureFromDb(String uid,String imageName) async{
//     try{
//       final ref =FirebaseStorage.instanceFor(bucket: "gs://meals-management-app-37e6a.appspot.com").ref().child("signatures/$uid/$imageName");
//       print(uid);
//       print("img name ${imageName}");
//       print(await ref.getDownloadURL());
//       return await ref.getDownloadURL();
//     }
//     catch(e){
// print("error $e");
//     }
//   }
}
