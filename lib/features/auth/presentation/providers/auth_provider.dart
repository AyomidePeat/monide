import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/network/error_handler.dart';
import 'package:monide/core/providers/app_providers.dart';
import 'package:monide/features/auth/data/repositories/auth_repo.dart';
import 'package:logger/logger.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authDataSourceProvider),
  );
});


class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final Logger _logger = Logger();

  AuthNotifier(this.authRepository) : super(AuthState());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _logger.i('Signing up user: $email');
      await authRepository.signUp(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } on ApiException catch (e) {
      _logger.e('ApiException during signUp: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error during signUp: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _logger.i('Signing in user: $email');
      await authRepository.signIn(email: email, password: password);
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } on ApiException catch (e) {
      _logger.e('ApiException during signIn: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error during signIn: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      _logger.i('Signing out user');
      await authRepository.signOut();
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    } on ApiException catch (e) {
      _logger.e('ApiException during signOut: ${e.message} (Code: ${e.statusCode})');
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error during signOut: $e\n$stackTrace');
      state = state.copyWith(isLoading: false, error: 'Unexpected error: $e');
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});