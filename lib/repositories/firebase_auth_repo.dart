
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpwithEmailandPassword(String email, String password) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print('some error occurred');
    }
    return null;
  }

  Future<User?> signInwithEmailandPassword(String email, String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print('some error occurred');
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