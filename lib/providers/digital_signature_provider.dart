import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/repositories/signature_repo.dart';

class SignatureProvider extends ChangeNotifier {
  final SignatureRepo _signRepo = SignatureRepo();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Uint8List? _imagebytes;

  Future<void> uploadImage(Uint8List pngBytes) async {
    _imagebytes = pngBytes;
    await _signRepo.uploadImageToDb(pngBytes, _auth.currentUser!.uid,
        DateTime.now().toString().substring(0, 10));
  }

  Future<void> getSignature() async {
    _imagebytes = await _signRepo.getSignatureFromDb(
        _auth.currentUser!.uid, DateTime.now().toString().substring(0, 10));
    notifyListeners();
  }

  get imageBytes => _imagebytes;
}
