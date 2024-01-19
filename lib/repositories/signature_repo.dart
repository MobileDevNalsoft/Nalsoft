import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class SignatureRepo {
  uploadImageToDb(Uint8List imageBytes, String uid, String imageName) async {
    try {
      final ref = FirebaseStorage.instanceFor(
              app: FirebaseAuth.instance.app,
              bucket: "gs://meals-management-app-37e6a.appspot.com")
          .ref()
          .child("signatures/$uid/$imageName");
      final uploadedImageBytes = ref.putData(imageBytes);

      print(uploadedImageBytes);
      print("upload done");

      //deleting all the signatures other thsn the latest one
      final refToDelete = FirebaseStorage.instanceFor(
              app: FirebaseAuth.instance.app,
              bucket: "gs://meals-management-app-37e6a.appspot.com")
          .ref()
          .child("/signatures/$uid");
      ListResult refToImageFiles = await refToDelete.listAll();

      for (Reference fileRef in refToImageFiles.items) {
        try {
          if (fileRef != ref) {
            await fileRef.delete();
            print("Deleted file: ${fileRef.name}");
          }
        } on FirebaseException catch (e) {
          print("Error deleting file: $e");
        }
      }
      print("done deleteing");

      return true;
      // final downloadUrl =  ref.getData();
      // print("download url $downloadUrl");
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }

  Future<String?> getSignatureFromDb(String uid, String imageName) async {
    try {
      final ref = FirebaseStorage.instanceFor(
              bucket: "gs://meals-management-app-37e6a.appspot.com")
          .ref()
          .child("/signatures/$uid/$imageName");
      print("image data ${ref.getData()}");
      return await ref.getDownloadURL();
    } catch (e) {
      print("Download error: $e");
      rethrow;
    }
  }
}
