
abstract class AuthRepository {
  Future<String> signUp(String name, String email, String password, String phoneNumber);
  Future<String> signIn(String email, String password);
  Future<void> signOut();
}