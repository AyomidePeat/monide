import 'package:monide/core/error/exceptions.dart';
import 'package:monide/features/auth/data/models/user_model.dart';
import 'package:monide/services/cloud_firestore.dart';
import 'package:monide/services/firebase_auth.dart';

class AuthRepository {
 final FirebaseAuthentication authService;
 final CloudFirestore firestoreService;

 AuthRepository({
 required this.authService,
 required this.firestoreService,
 });

 Future<UserModel> signIn(String email, String password) async {
 if (email.isEmpty || password.isEmpty) {
 throw AuthException('Please fill up all fields');
 }
 try {
 final userCredential = await authService.signIn(
 email: email.trim(),
 password: password.trim(),
 );
 final userDetails = await firestoreService.getUserDetails();
 if (userDetails == null) {
 throw AuthException('User details not found');
 }
 return UserModel(
 uid: userCredential.user!.uid,
 name: userDetails.name,
 email: userDetails.email,
 phoneNumber: userDetails.phoneNumber,
 );
 } catch (e) {
 throw AuthException(e.toString());
 }
 }

 Future<UserModel> signUp({
 required String name,
 required String email,
 required String password,
 required String phoneNumber,
 }) async {
 if (name.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
 throw AuthException('Please fill up all fields');
 }
 try {
 final userCredential = await authService.signUp(
 name: name.trim(),
 email: email.trim(),
 password: password.trim(),
 phoneNumber: phoneNumber.trim(),
 );
 final userDetails = UserModel(
 uid: userCredential.user!.uid,
 name: name.trim(),
 email: email.trim(),
 phoneNumber: phoneNumber.trim(),
 );
 await firestoreService.uploadUserDetailsToDatabase(user: userDetails);
 return userDetails;
 } catch (e) {
 throw AuthException(e.toString());
 }
 }

 Future<void> signOut() async {
 try {
 await authService.signOut();
 } catch (e) {
 throw AuthException(e.toString());
 }
 }
}