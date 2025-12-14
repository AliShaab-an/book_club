import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/entities/user.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.signIn(email: email, password: password);
  }
}
