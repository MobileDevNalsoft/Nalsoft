import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meals_management/repositories/signature_repo.dart';

class SignatureProvider extends ChangeNotifier {
  final SignatureRepo _signRepo = SignatureRepo();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Uint8List? _imagebytes;
  String? _url;

  Future<void> uploadImage(Uint8List pngBytes) async {
    _imagebytes = pngBytes;
    await _signRepo.uploadImageToDb(pngBytes, _auth.currentUser!.uid,
        DateTime.now().toString().substring(0, 10));
  }

  Future<void> setSignatureUrl() async {
    _url = await _signRepo.getSignatureURLFromDb(
        _auth.currentUser!.uid, DateTime.now().toString().substring(0, 10));
    notifyListeners();
  }

  get getImageBytes => _imagebytes;
  get getURL => _url;
}
