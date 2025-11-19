import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException(this.errorModel);
}

class CacheException implements Exception {
  final String errorMessage;

  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handelHttpException(Object error, {http.Response? response}) {
  if (error is SocketException) {
    throw ConnectionErrorException(
      ErrorModel(status: 500, errorMessage: "No Internet connection."),
    );
  } else if (error is TimeoutException) {
    throw ConnectionErrorException(
      ErrorModel(status: 500, errorMessage: "Request timed out."),
    );
  } else if (response != null) {
    try {
      final data = jsonDecode(response.body);

      switch (response.statusCode) {
        case 400:
          throw BadResponseException(ErrorModel.fromJson(data));
        case 401:
          throw UnauthorizedException(ErrorModel.fromJson(data));
        case 403:
          throw ForbiddenException(ErrorModel.fromJson(data));
        case 404:
          throw NotFoundException(ErrorModel.fromJson(data));
        case 409:
          throw CofficientException(ErrorModel.fromJson(data));
        case 504:
          throw BadResponseException(
            ErrorModel(status: 504, errorMessage: "Gateway timeout"),
          );
        default:
          throw UnknownException(ErrorModel.fromJson(data));
      }
    } catch (e) {
      throw UnknownException(
        ErrorModel(status: 500, errorMessage: "Unexpected error format."),
      );
    }
  } else {
    throw UnknownException(
      ErrorModel(status: 500, errorMessage: error.toString()),
    );
  }
}
