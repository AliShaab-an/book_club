import 'package:client/core/databases/cache/cache_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

final tokenProvider = StateNotifierProvider<TokenNotifier, String?>((ref) {
  return TokenNotifier();
});

class TokenManager {
  static const String _tokenKey = 'auth_token';
  final CacheHelper _cacheHelper = GetIt.instance<CacheHelper>();

  Future<void> saveToken(String token) async {
    await _cacheHelper.saveData(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _cacheHelper.getDataString(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _cacheHelper.removeData(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

class TokenNotifier extends StateNotifier<String?> {
  TokenNotifier() : super(null) {
    _loadToken();
  }

  final TokenManager _tokenManager = TokenManager();

  Future<void> _loadToken() async {
    state = await _tokenManager.getToken();
  }

  Future<void> setToken(String token) async {
    await _tokenManager.saveToken(token);
    state = token;
  }

  Future<void> clearToken() async {
    await _tokenManager.clearToken();
    state = null;
  }

  bool get isAuthenticated => state != null && state!.isNotEmpty;
}
