import 'dart:io';

class ServerConstant {

  static const String _pcIp = "192.168.1.9";
  static String serverUrl = Platform.isAndroid
      ? 'http://$_pcIp:8000'
      : 'http://127.0.0.1:8000';
}
