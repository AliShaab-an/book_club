import 'package:client/core/services/http_service.dart';
import 'package:client/core/services/token_manager.dart';
import 'package:client/features/auth/data/repositories/auth_remote_repository_impl.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final httpService = ref.read(httpServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return AuthRemoteRepositoryImpl(
    httpService: httpService,
    tokenManager: tokenManager,
  );
});
