import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, User>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }
}
