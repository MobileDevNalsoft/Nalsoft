import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class FirebaseAuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') { 
        print( 'The email address is already in use.');
      } else {
        print( 'An error occurred: ${e.code}');
      }
    }

    return null;

  }


  Future signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("user present");
      print(_auth.currentUser!.uid);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password'||e.code == 'user-not-found'  ) {
        print( 'Invalid email or password.');
      } else {
        print( 'An error occurred: ${e.code}');
      }

    }
    return null;

  }
 Future<void> signOutNow() async {
    try{
      await _auth.signOut();
    }catch(e){
      print('some error has occurred');
    }
  }



}

