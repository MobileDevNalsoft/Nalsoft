import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignatureRepo {
  uploadImageToDb(Uint8List imageBytes, String uid, String imageName) async {
    try {
      final ref = FirebaseStorage.instanceFor(
              app: FirebaseAuth.instance.app,
              bucket: "gs://meals-management-app-37e6a.appspot.com")
          .ref()
          .child("signatures/$uid/$imageName");
      final uploadedImageBytes = ref.putData(imageBytes);

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

      return true;
      // final downloadUrl =  ref.getData();
      // print("download url $downloadUrl");
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }

  Future<Uint8List?> getSignatureFromDb(String uid, String imageName) async {
    try {
      final ref = FirebaseStorage.instanceFor(
              bucket: "gs://meals-management-app-37e6a.appspot.com")
          .ref()
          .child("/signatures/$uid/$imageName");
      print("image data ${ref.getData()}");
      return await ref.getData();
    } catch (e) {
      print("Download error: $e");
      rethrow;
    }
  }
}