import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smart_installment_management/core/costants/strings_keys.dart';


class ApiException implements Exception {
  final String message;
  final String key;

  ApiException({required this.message, required this.key});

  @override
  String toString() => key; 
}
class ApiErrorHandler {
   static String handleDioErrorKey(DioException error, {bool isRegister=false}) {
    if (error.error is SocketException) {
      return StringKeys.noInternetConnection;
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return StringKeys.connectionTimedOut;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
         final   String key = _keyForStatus(statusCode);

        return key;
      case DioExceptionType.cancel:
        return StringKeys.requestCancelled;

      default:
        return error.response as String;
    }
  }

  static String _keyForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return StringKeys.invalidEmailOrPassword;
      case 401:
        return StringKeys.unauthorized;
      case 404:
        return StringKeys.resourceNotFound;
      case 500:
        return StringKeys.serverError;
      case 503:
        return StringKeys.serviceUnavailable;
      default:
        return StringKeys.unexpectedError;
    }
  }

  static String handleStatusCodeKey(int? statusCode,  {bool isRegister=false}) {
    return _keyForStatus(statusCode);
  }

  static String handleUnknownErrorKey(Object e) {
    return StringKeys.unexpectedError;
  }
}
