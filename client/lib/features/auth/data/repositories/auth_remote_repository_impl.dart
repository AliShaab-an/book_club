import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/auth/data/models/user_model.dart';
import 'package:client/features/auth/domain/entities/user.dart';
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

      return result.fold((failure) => Left(failure), (data) async {
        // Extract token from response (could be 'token' or 'access_token')
        final token =
            data['token']?.toString() ?? data['access_token']?.toString();

        if (token != null && token.isNotEmpty) {
          // Save token
          await tokenManager.saveToken(token);
        }

        // Create user model
        final user = UserModel(
          id: data['id']?.toString() ?? '',
          firstName: data['first_name']?.toString() ?? firstName,
          lastName: data['last_name']?.toString() ?? lastName,
          email: data['email']?.toString() ?? email,
          token: token ?? '',
        );

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
      print(
        'DEBUG signIn repo: Sending request to /auth/token with email: $email',
      );
      // FastAPI OAuth2 expects application/x-www-form-urlencoded
      final result = await httpService.postFormUrlEncoded('/auth/token', {
        'username': email, // FastAPI OAuth2 uses 'username' field
        'password': password,
      });

      return result.fold(
        (failure) {
          print('DEBUG signIn repo: Request failed - ${failure.errMessage}');
          return Left(failure);
        },
        (data) async {
          print('DEBUG signIn repo: Response received - $data');
          // Parse the access_token from response
          final token = data['access_token'] as String?;
          print('DEBUG signIn repo: Parsed token: $token');
          if (token == null || token.isEmpty) {
            print('DEBUG signIn repo: Token is null or empty');
            return Left(AuthFailure(message: 'No access token received'));
          }

          // Save token using SharedPreferences via TokenManager
          await tokenManager.saveToken(token);
          print('DEBUG signIn repo: Token saved');

          // Get token type (usually "bearer")
          final tokenType = data['token_type'] as String? ?? 'bearer';

          // Create user model with token
          final user = UserModel(
            id: '', // Will be populated from /users/me endpoint if needed
            firstName: '',
            lastName: '',
            email: email,
            token: token,
          );
          print(
            'DEBUG signIn repo: Returning user - email: ${user.email}, token: ${user.token}',
          );
          return Right(user);
        },
      );
    } catch (e) {
      print('DEBUG signIn repo: Exception caught - $e');
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
