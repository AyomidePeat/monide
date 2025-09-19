import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class ErrorHandler {
  static final Logger _logger = Logger();

  static ApiException handleError(dynamic e) {
    if (e is DioException) {
      return _handleDioError(e);
    } else if (e is FirebaseAuthException) {
      return _handleFirebaseAuthError(e);
    } else if (e is FirebaseException) {
      return _handleFirebaseFirestoreError(e);
    } else {
      _logger.e('Unexpected error: $e');
      return ApiException(message: 'An unexpected error occurred: $e');
    }
  }

  static ApiException _handleDioError(DioException e) {
    final String apiMessage = e.response?.data?['message'] as String? ??
        e.response?.data?['error'] as String? ??
        'An unexpected error occurred: ${e.message}';
    final int? statusCode = e.response?.statusCode;

    _logger.e("API Error: $apiMessage (Code: $statusCode, URL: ${e.requestOptions.uri})");

    final String userMessage = _getUserFriendlyMessage(
      statusCode,
      apiMessage,
      e.requestOptions.uri.toString(),
    );

    return ApiException(message: userMessage, statusCode: statusCode);
  }

  static ApiException _handleFirebaseAuthError(FirebaseAuthException e) {
    final String errorCode = e.code;
    final String apiMessage = e.message ?? 'Authentication failed';

    _logger.e("Firebase Auth Error: $apiMessage (Code: $errorCode)");

    final String userMessage = _getUserFriendlyFirebaseAuthMessage(errorCode, apiMessage);

    return ApiException(message: userMessage, statusCode: _mapFirebaseAuthCodeToStatus(errorCode));
  }

  static ApiException _handleFirebaseFirestoreError(FirebaseException e) {
    final String errorCode = e.code;
    final String apiMessage = e.message ?? 'Firestore operation failed';

    _logger.e("Firestore Error: $apiMessage (Code: $errorCode)");

    final String userMessage = _getUserFriendlyFirestoreMessage(errorCode, apiMessage);

    return ApiException(message: userMessage, statusCode: _mapFirebaseFirestoreCodeToStatus(errorCode));
  }

  static String _getUserFriendlyMessage(
    int? statusCode,
    String apiMessage,
    String requestUri,
  ) {
    final bool isLocationRequest = requestUri.contains('/reverse.php') ||
        requestUri.contains('/nearby.php') ||
        requestUri.contains('/search.php');

    switch (statusCode) {
      case 400:
        return isLocationRequest
            ? 'Invalid location data. Please try again.'
            : apiMessage;
      case 401:
        return 'Invalid API key. Please contact support.';
      case 403:
        return 'Access denied. Please check your API key or permissions.';
      case 404:
        return isLocationRequest
            ? 'No ATMs or location found. Try a different area.'
            : apiMessage;
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return apiMessage.contains('Network error') ||
                apiMessage.contains('Failed to connect')
            ? 'Unable to connect to the server. Please check your internet.'
            : 'An error occurred. Please try again.';
    }
  }

  static String _getUserFriendlyFirebaseAuthMessage(String errorCode, String apiMessage) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please sign in or use a different email.';
      case 'invalid-email':
        return 'Invalid email format. Please enter a valid email.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return apiMessage;
    }
  }

  static String _getUserFriendlyFirestoreMessage(String errorCode, String apiMessage) {
    switch (errorCode) {
      case 'permission-denied':
        return 'You do not have permission to access this data. Please contact support.';
      case 'not-found':
        return 'Requested data not found. Please try again.';
      case 'unavailable':
        return  'Please check your internet connection.';
      case 'deadline-exceeded':
        return 'Operation took too long. Please try again.';
      case 'already-exists':
        return 'Data already exists. Please try again.';
      default:
        return 'An error occurred while accessing Firestore. Please try again.';
    }
  }

  static int? _mapFirebaseAuthCodeToStatus(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 401; // Unauthorized
      case 'email-already-in-use':
        return 409; // Conflict
      case 'invalid-email':
      case 'weak-password':
        return 400; // Bad Request
      case 'too-many-requests':
        return 429; // Too Many Requests
      case 'user-disabled':
        return 403; // Forbidden
      default:
        return null; // Unknown
    }
  }

  static int? _mapFirebaseFirestoreCodeToStatus(String errorCode) {
    switch (errorCode) {
      case 'permission-denied':
        return 403; // Forbidden
      case 'not-found':
        return 404; // Not Found
      case 'unavailable':
      case 'deadline-exceeded':
        return 503; // Service Unavailable
      case 'already-exists':
        return 409; // Conflict
      default:
        return null; // Unknown
    }
  }
}