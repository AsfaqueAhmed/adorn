import 'package:adorn/base/networking/network_service.dart';

class NetworkError extends Error {
  final dynamic _error;

  String get error => _error;

  NetworkError.fromResponse(NetworkResponse response)
      : _error = response.message;
}
