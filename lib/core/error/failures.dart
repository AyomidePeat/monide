abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}