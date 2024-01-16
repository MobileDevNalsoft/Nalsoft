import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management_with_firebase/repositories/signature_repo.dart';

class SignatureProvider extends ChangeNotifier{
  
  final SignatureRepo _signRepo = SignatureRepo();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? imageName;
  bool isUploaded =false;
  Uint8List? _imagebytes;
  get imageBytes => _imagebytes;

 void uploadImage(Uint8List pngBytes) async {
  imageName="${DateTime.now().millisecondsSinceEpoch}";
  // _imagebytes=pngBytes;
  if(await _signRepo.uploadImageToDb(pngBytes, _auth.currentUser!.uid,imageName!)){
    isUploaded=true;
  }
  else{
    isUploaded=false;
  }
 }

 Future<void> getSignature() async {
  print("imageName: ${imageName}");
   _imagebytes= await _signRepo.getSignatureFromDb(_auth.currentUser!.uid,imageName!);
   print(imageBytes);
  notifyListeners();  
 }
}