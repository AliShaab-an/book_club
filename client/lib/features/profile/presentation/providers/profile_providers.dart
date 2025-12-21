import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:client/features/profile/domain/entities/app_user.dart';
import 'package:client/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return ProfileRepositoryImpl(
    httpService: httpService,
    tokenManager: tokenManager,
  );
});

// Current User Provider
final currentUserProvider = FutureProvider<AppUser>((ref) async {
  final repository = ref.read(profileRepositoryProvider);
  final result = await repository.getCurrentUser();

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (user) => user,
  );
});

// Update User Provider
final updateUserProvider = FutureProvider.family<AppUser, AppUser>((
  ref,
  user,
) async {
  final repository = ref.read(profileRepositoryProvider);
  final result = await repository.updateUser(user);

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (updatedUser) => updatedUser,
  );
});

// Change Password Provider
final changePasswordProvider = FutureProvider.family<void, Map<String, String>>(
  (ref, passwords) async {
    final repository = ref.read(profileRepositoryProvider);
    final result = await repository.changePassword(
      currentPassword: passwords['currentPassword']!,
      newPassword: passwords['newPassword']!,
      confirmPassword: passwords['confirmPassword']!,
    );

    return result.fold(
      (failure) => throw Exception(failure.errMessage),
      (success) => success,
    );
  },
);

// Logout Provider
final logoutProvider = FutureProvider<void>((ref) async {
  final repository = ref.read(profileRepositoryProvider);
  final result = await repository.logout();

  return result.fold(
    (failure) => throw Exception(failure.errMessage),
    (success) => success,
  );
});
