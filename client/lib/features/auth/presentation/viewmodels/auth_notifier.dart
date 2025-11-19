import 'package:client/core/services/token_manager.dart';
import 'package:client/features/auth/data/providers/auth_providers.dart';
import 'package:client/features/auth/domain/usecases/is_authenticated.dart';
import 'package:client/features/auth/domain/usecases/sign_in.dart';
import 'package:client/features/auth/domain/usecases/sign_out.dart';
import 'package:client/features/auth/domain/usecases/sign_up.dart';
import 'package:client/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final repository = _ref.read(authRepositoryProvider);
    final isAuth = await IsAuthenticated(repository).call();
    state = state.copyWith(isAuthenticated: isAuth);
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = _ref.read(authRepositoryProvider);
    final result = await SignUp(repository).call(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.errMessage);
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
        );
        // Update token provider
        _ref.read(tokenProvider.notifier).setToken(user.token);
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    final repository = _ref.read(authRepositoryProvider);
    final result = await SignIn(
      repository,
    ).call(email: email, password: password);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.errMessage);
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
        );
        // Update token provider
        _ref.read(tokenProvider.notifier).setToken(user.token);
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    final repository = _ref.read(authRepositoryProvider);
    final result = await SignOut(repository).call();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.errMessage);
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          user: null,
          isAuthenticated: false,
        );
        // Clear token provider
        _ref.read(tokenProvider.notifier).clearToken();
      },
    );
  }

  void clearError() {
    state = state.clearError();
  }
}
