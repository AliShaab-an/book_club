import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/profile/data/models/user_model.dart';
import 'package:client/features/profile/domain/entities/app_user.dart';
import 'package:client/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final HttpService httpService;
  final TokenManager tokenManager;

  ProfileRepositoryImpl({
    required this.httpService,
    required this.tokenManager,
  });

  @override
  Future<Either<Failure, AppUser>> getCurrentUser() async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.get('/users/me', token: token);

      return result.fold((failure) => Left(failure), (data) {
        final user = UserModel.fromMap(data);
        return Right(user);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateUser(AppUser user) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
        favoriteGenres: user.favoriteGenres,
      );

      final result = await httpService.put(
        '/users/me',
        userModel.toMap(),
        token: token,
      );

      return result.fold((failure) => Left(failure), (data) {
        final updatedUser = UserModel.fromMap(data);
        return Right(updatedUser);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return Left(AuthFailure(message: 'Not authenticated'));
      }

      final result = await httpService.put('/users/change-password', {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirm': confirmPassword,
      }, token: token);

      return result.fold((failure) => Left(failure), (_) => const Right(null));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenManager.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
