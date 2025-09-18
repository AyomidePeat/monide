import 'package:logger/logger.dart';
import 'package:monide/core/network/error_handler.dart';
import 'package:monide/features/auth/data/datasources/auth_data_source.dart';

class AuthRepository {
  final AuthDataSource authDataSource;
  final Logger _logger = Logger();

  AuthRepository(this.authDataSource);

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      await authDataSource.signUp(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
    } on ApiException catch (e) {
      _logger.e('ApiException in signUp: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in signUp: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await authDataSource.signIn(email: email, password: password);
    } on ApiException catch (e) {
      _logger.e('ApiException in signIn: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in signIn: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await authDataSource.signOut();
    } on ApiException catch (e) {
      _logger.e('ApiException in signOut: ${e.message} (Code: ${e.statusCode})');
      throw ApiException(message: e.message, statusCode: e.statusCode);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error in signOut: $e\n$stackTrace');
      throw ApiException(message: 'Unexpected error: $e');
    }
  }
}