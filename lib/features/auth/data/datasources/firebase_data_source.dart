import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:monide/core/network/error_handler.dart';
import 'package:monide/features/auth/data/models/user_model.dart';
import '../../../../domain/entities/atm_status.dart';

class FirestoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final Logger _logger = Logger();

  FirestoreDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> uploadUserDetails(UserDetails user) async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        _logger.w('No authenticated user found for uploadUserDetails');
        throw ApiException(message: 'No authenticated user found');
      }
      await firestore.collection('users').doc(userId).set(user.toJson());
      _logger.i('User details uploaded for UID: $userId');
    } on FirebaseException catch (e) {
      _logger.e('Firestore error in uploadUserDetails: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in uploadUserDetails: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<UserDetails?> getUserDetails() async {
    try {
      final userId = firebaseAuth.currentUser?.uid;
      if (userId == null) {
        _logger.w('No authenticated user found for getUserDetails');
        throw ApiException(message: 'No authenticated user found');
      }
      final snapshot = await firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        _logger.i('User details fetched for UID: $userId');
        return UserDetails.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      _logger.w('No user details found for UID: $userId');
      return null;
    } on FirebaseException catch (e) {
      _logger.e('Firestore error in getUserDetails: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in getUserDetails: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<void> uploadAtmStatus(AtmStatus atm, String uid) async {
    try {
      await firestore.collection('ATM Status').doc(uid).set(atm.toJson());
      _logger.i('ATM status uploaded for UID: $uid');
    } on FirebaseException catch (e) {
      _logger.e('Firestore error in uploadAtmStatus: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in uploadAtmStatus: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<AtmStatus?> getAtmStatus(String uid) async {
    try {
      final snapshot = await firestore.collection('ATM Status').doc(uid).get();
      if (snapshot.exists) {
        _logger.i('ATM status fetched for UID: $uid');
        return AtmStatus.getModelFromJson(json: snapshot.data() as Map<String, dynamic>);
      }
      _logger.w('No ATM status found for UID: $uid');
      return null;
    } on FirebaseException catch (e) {
      _logger.e('Firestore error in getAtmStatus: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in getAtmStatus: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }
}