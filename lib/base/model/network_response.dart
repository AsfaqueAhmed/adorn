import 'dart:convert';

import 'package:adorn/base/service/network_service.dart';

class NetworkResponse {
  bool hasError = false;
  int error = NetworkErrors.none;
  dynamic message;
  dynamic response;
  DateTime dateTime = DateTime.now();
  bool latest = false;

  NetworkResponse({this.hasError = false, this.message, this.response});

  NetworkResponse.fromJson({required Map<String, dynamic> json}) {
    hasError = json['hasError'];
    message = json['message'];
    response = json['response'];
    dateTime = DateTime.parse(json['dateTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'hasError': hasError,
      "message": message,
      'response': response is String ? response : jsonEncode(response),
      'date': dateTime.toString(),
    };
  }
}
