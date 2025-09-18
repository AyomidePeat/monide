import 'package:firebase_auth/firebase_auth.dart';
import 'package:monide/domain/entities/user.dart';
import 'package:monide/features/auth/data/models/user_model.dart';
import 'cloud_firestore.dart';

class FirebaseAuthentication {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CloudFirestore cloudFirestore = CloudFirestore();

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
}
