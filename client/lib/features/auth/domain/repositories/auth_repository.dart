import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/entites/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<bool> isAuthenticated();
}
