import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:road_mechanic/model/user_model.dart';

import '../screens/home_screen.dart';
import 'cloud_firestore.dart';

class FirebaseAuthentication {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CloudFirestore cloudFirestore = CloudFirestore();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signUp(
      {required String name,
      required String email,
      required String password,
      required String phoneNumber}) async {
    name.trim();

    email.trim();
    password.trim();
    phoneNumber.trim();
    String output = 'Something went wrong';

    if (name != '' && email != '' && password != '' && phoneNumber != '') {
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserDetails user = UserDetails(name: name, phoneNumber: phoneNumber);
        await CloudFirestore.uploadUserDetailsToDatabase(user: user);
        output = 'Success';
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = 'Please fill up all fields';
    }
    return output;
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Something went wrong";
    if (email != "" && password != "") {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        output = "Success";
      } on FirebaseAuthException catch (e) {
        output = e.message.toString();
      }
    } else {
      output = "Please fill up all the fields.";
    }
    return output;
  }

  Future<String> signOut() async {
    String output = '';
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      e.message.toString();
    }
    return output;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        // Obtain the Google Sign-In authentication details
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        // Create a new credential
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase with the Google credential
        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);

        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      print('Failed to sign in with Google: $e');
    }
    return null;
  }

  static Future<FirebaseApp> initializeFirebase({
  required BuildContext context,
}) async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          user: user
        ),
      ),
    );
  }

  return firebaseApp;
}
}
