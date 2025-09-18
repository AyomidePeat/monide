import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monide/core/error/exceptions.dart';
import 'package:monide/features/auth/data/models/user_model.dart';
import 'package:monide/features/auth/data/repositories/auth_repo.dart';
import 'package:monide/services/cloud_firestore.dart';
import 'package:monide/services/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuthentication>(
 (ref) => FirebaseAuthentication(),
);
final cloudFirestoreProvider = Provider<CloudFirestore>(
 (ref) => CloudFirestore(),
);
final authRepositoryProvider = Provider<AuthRepository>(
 (ref) => AuthRepository(
 authService: ref.read(firebaseAuthProvider),
 firestoreService: ref.read(cloudFirestoreProvider),
 ),
);

class AuthState {
 final bool isLoading;
 final String? error;
 final UserModel? user;

 AuthState({
 this.isLoading = false,
 this.error,
 this.user,
 });

 AuthState copyWith({
 bool? isLoading,
 String? error,
 UserModel? user,
 }) {
 return AuthState(
 isLoading: isLoading ?? this.isLoading,
 error: error,
 user: user ?? this.user,
 );
 }
}

final authStateProvider =
 StateNotifierProvider<AuthStateNotifier, AuthState>(
 (ref) => AuthStateNotifier(ref),
);

class AuthStateNotifier extends StateNotifier<AuthState> {
 final Ref ref;

 AuthStateNotifier(this.ref) : super(AuthState());

 Future<void> signIn(String email, String password) async {
 state = state.copyWith(isLoading: true, error: null);
 try {
 final user = await ref.read(authRepositoryProvider).signIn(email, password);
 state = state.copyWith(isLoading: false, user: user);
 } on AuthException catch (e) {
 state = state.copyWith(isLoading: false, error: e.message);
 }
 }

 Future<void> signUp({
 required String name,
 required String email,
 required String password,
 required String phoneNumber,
 }) async {
 state = state.copyWith(isLoading: true, error: null);
 try {
 final user = await ref.read(authRepositoryProvider).signUp(
 name: name,
 email: email,
 password: password,
 phoneNumber: phoneNumber,
 );
 state = state.copyWith(isLoading: false, user: user);
 } on AuthException catch (e) {
 state = state.copyWith(isLoading: false, error: e.message);
 }
 }
}