import 'package:client/core/errors/failure.dart';
import 'package:client/features/profile/domain/entities/app_user.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRepository {
  Future<Either<Failure, AppUser>> getCurrentUser();
  Future<Either<Failure, AppUser>> updateUser(AppUser user);
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
  Future<Either<Failure, void>> logout();
}
