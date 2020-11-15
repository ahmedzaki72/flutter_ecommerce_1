import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/user_modal.dart';

class Auth {

  FirebaseAuth _auth = FirebaseAuth.instance;

  /// this is function signUp
  Future<UserCredential> signUp(String name,String email, String password) async {

      UserCredential  userCredential = await  _auth.createUserWithEmailAndPassword(email: email, password: password);
      CollectionReference _users = FirebaseFirestore.instance.collection(kUsers);
      _users.add({
        'name' : name,
        'email' :email,
      });
      return userCredential;

  }

  /// this is function signIn
  Future<UserCredential> signIn(String email,String password  ) async{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
  }

  Future<void> signOut() async{
     await _auth.signOut();
  }


}