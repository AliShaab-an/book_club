import 'dart:convert';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/errors/failure.dart';
import 'package:client/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpServiceProvider = Provider<HttpService>((ref) {
  return HttpService();
});

class HttpService {
  final String baseUrl = ServerConstant.serverUrl;
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Map<String, String> _getHeaders({String? token}) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<Either<Failure, Map<String, dynamic>>> get(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> delete(
    String endpoint, {
    String? token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(token: token),
      );

      return _handleResponse(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Either<Failure, Map<String, dynamic>> _handleResponse(
    http.Response response,
  ) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) {
          return const Right({});
        }
        return Right(jsonDecode(response.body));
      case 400:
        return Left(
          ValidationFailure(message: _extractErrorMessage(response.body)),
        );
      case 401:
        return Left(AuthFailure(message: _extractErrorMessage(response.body)));
      case 403:
        return Left(AuthFailure(message: 'Access forbidden'));
      case 404:
        return Left(ServerFailure(message: 'Resource not found'));
      case 422:
        return Left(
          ValidationFailure(message: _extractErrorMessage(response.body)),
        );
      case 500:
        return Left(ServerFailure(message: 'Internal server error'));
      default:
        return Left(
          ServerFailure(message: 'Unknown error: ${response.statusCode}'),
        );
    }
  }

  String _extractErrorMessage(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is Map<String, dynamic>) {
        return decoded['detail'] ?? decoded['message'] ?? 'Unknown error';
      }
      return responseBody;
    } catch (e) {
      return responseBody;
    }
  }
}
