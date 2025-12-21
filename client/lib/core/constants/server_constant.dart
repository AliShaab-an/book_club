import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ServerConstant {
  static String get serverUrl {
    if (Platform.isAndroid) {
      return dotenv.env['API_BASE_URL_ANDROID'] ?? 'http://192.168.1.3:8000';
    } else if (Platform.isIOS) {
      return dotenv.env['API_BASE_URL_IOS'] ?? 'http://127.0.0.1:8000';
    } else {
      return dotenv.env['API_BASE_URL_WEB'] ?? 'http://127.0.0.1:8000';
    }
  }
}
