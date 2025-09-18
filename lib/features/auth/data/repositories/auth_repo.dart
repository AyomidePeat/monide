import 'package:monide/core/error/exceptions.dart';
import 'package:monide/core/error/failures.dart';
import 'package:monide/features/auth/data/datasources/auth_data_source.dart';


class AuthRepository {
  final AuthDataSource authDataSource;

  AuthRepository(this.authDataSource);

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty || phoneNumber.isEmpty) {
        throw AuthException('All fields are required');
      }
      await authDataSource.signUp(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure('An unexpected error occurred');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw AuthException('Email and password are required');
      }
      await authDataSource.signIn(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } catch (e) {
      throw AuthFailure('An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await authDataSource.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }
}