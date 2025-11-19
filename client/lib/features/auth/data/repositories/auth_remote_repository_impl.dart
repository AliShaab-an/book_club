import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/auth/data/models/user_model.dart';
import 'package:client/features/auth/domain/entites/user.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRemoteRepositoryImpl implements AuthRepository {
  final HttpService httpService;
  final TokenManager tokenManager;

  AuthRemoteRepositoryImpl({
    required this.httpService,
    required this.tokenManager,
  });

  @override
  Future<Either<Failure, User>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final result = await httpService.post('/auth/', {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      });

      return result.fold((failure) => Left(failure), (data) {
        final user = UserModel.fromMap(data);
        return Right(user);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // FastAPI OAuth2 expects form data
      final result = await httpService.post('/auth/token', {
        'username': email, // FastAPI OAuth2 uses 'username' field
        'password': password,
        'grant_type': 'password',
      });

      return result.fold((failure) => Left(failure), (data) async {
        final token = data['access_token'] as String;
        await tokenManager.saveToken(token);

        // You might need to get user info after login
        // For now, creating a user with token
        final user = UserModel(
          id: '', // You might need to get this from a separate endpoint
          firstName: '',
          lastName: '',
          email: email,
          token: token,
        );
        return Right(user);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await tokenManager.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await tokenManager.getToken();
      if (token == null) {
        return const Right(null);
      }

      // You might have an endpoint to get current user
      // For now, returning null if no user endpoint exists
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await tokenManager.hasToken();
  }
}
