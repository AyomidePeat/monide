

import 'package:firebase_auth/firebase_auth.dart';
import 'package:monide/model/atm_status_model.dart';

abstract class FirestoreRepository {
  Future<void> uploadUserDetails(User user);
  Future<User?> getUserDetails();
  Future<void> uploadAtmStatus(AtmStatus atmStatus, String uid);
  Future<AtmStatus?> getAtmStatus(String uid);
}