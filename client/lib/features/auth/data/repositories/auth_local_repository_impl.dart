import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalRepositoryImpl {
  final SharedPreferences sharedPreferences;

  AuthLocalRepositoryImpl(this.sharedPreferences);

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString('x-auth-token', token);
  }

  String? getToken() {
    return sharedPreferences.getString('x-auth-token');
  }
}
