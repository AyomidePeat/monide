import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:monide/core/network/error_handler.dart';

class AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final Logger _logger = Logger();

  AuthDataSource(this.firebaseAuth);

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await userCredential.user?.updateDisplayName(name.trim());
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase signUp error: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected signUp error: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase signIn error: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected signIn error: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      _logger.e('Firebase signOut error: ${e.message} (Code: ${e.code})');
      throw ErrorHandler.handleError(e);
    } catch (e, stackTrace) {
      _logger.e('Unexpected signOut error: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }
}