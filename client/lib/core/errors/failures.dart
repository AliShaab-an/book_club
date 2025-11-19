import 'failure.dart';

class ServerFailure extends Failure {
  ServerFailure({String message = 'Server error occurred'}) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure({String message = 'Authentication failed'}) : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure({String message = 'Validation error'}) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure({String message = 'Network connection failed'})
    : super(message);
}

class CacheFailure extends Failure {
  CacheFailure({String message = 'Cache operation failed'}) : super(message);
}
