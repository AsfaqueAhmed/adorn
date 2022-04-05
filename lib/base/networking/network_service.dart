import 'dart:convert';
import 'package:adorn/base/networking/error_processor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class NetworkService {
  Dio? _dio;

  static NetworkErrorProcessor? errorProcessor;

  static final NetworkService _networkController = NetworkService._();

  factory NetworkService() => _networkController;

  NetworkService._() {
    _dio = Dio();
  }

  resetBearerToken() {
    _dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'allowWithoutToken': true
    };
  }

  updateBearerToken({required String token}) {
    _dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  updateToken({required String token}) {
    _dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$token',
    };
  }

  Future<NetworkResponse> post(String endPoint, {
    Map<String, dynamic>? requestData,
    RequestType requestType = RequestType.formData,
  }) async {
    if (kDebugMode) {
      print(jsonEncode(requestData));
      print(endPoint);
    }

    Response? resp;
    NetworkResponse response = NetworkResponse();
    try {
      resp = await _dio?.post(endPoint,
          data: requestType == RequestType.raw
              ? requestData
              : requestData == null
              ? null
              : FormData.fromMap(requestData));
    } on DioError catch (error) {
      response.hasError = true;
      _processErrors(error, response);
      return response;
    } catch (e) {
      response.hasError = true;
    }

    if (response.hasError) {
      return response;
    }
    if (kDebugMode) log(resp?.data?.toString()??'');

    response.response = resp?.data;

    return response;
  }

  Future<NetworkResponse> get(String endPoint,
      {Map<String, dynamic>? requestData}) async {
    if (kDebugMode) print(jsonEncode(requestData));

    if (kDebugMode) print(endPoint);

    NetworkResponse response = NetworkResponse();
    Response? resp;

    try {
      resp = await _dio?.get(endPoint, queryParameters: requestData);
    } on DioError catch (error) {
      response.hasError = true;
      _processErrors(error, response);
      return response;
    } catch (e) {
      response.hasError = true;
    }

    if (response.hasError) {
      return response;
    }
    if (kDebugMode) log(resp?.data?.toString()??'');
    response.response = resp?.data;

    return response;
  }

  _processErrors(DioError error, NetworkResponse response) {
    if (errorProcessor == null) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
          response.message = 'Connection Timeout';
          break;
        case DioErrorType.sendTimeout:
          response.message = 'Send timeout';
          break;
        case DioErrorType.receiveTimeout:
          response.message = 'Receive timeout';
          break;
        case DioErrorType.response:
          if (kDebugMode) {
            log(error.response?.data?.toString()??"");
          }
          response.message = 'Error processing request';
          response.response = error.response?.data;
          break;
        case DioErrorType.cancel:
          response.message = 'Request canceled';
          break;
        default:
          response.message = 'Error api response';
          break;
      }
    } else {
      response.response = error.response?.data;
      switch (error.type) {
        case DioErrorType.connectTimeout:
          response.message = errorProcessor?.onConnectionTimeout();
          break;
        case DioErrorType.sendTimeout:
          response.message = errorProcessor?.onSendTimeout();
          break;
        case DioErrorType.receiveTimeout:
          response.message = errorProcessor?.onReceiveTimeout();
          break;
        case DioErrorType.response:
          response.message = errorProcessor?.onResponseError(
              error.response?.statusCode, error.response);
          break;
        case DioErrorType.cancel:
          response.message = errorProcessor?.onCancel();
          break;
        case DioErrorType.other:
          response.message = errorProcessor?.onOtherError();
          break;
      }
    }
  }
}

enum RequestType { formData, raw }

class NetworkResponse {
  bool hasError;
  dynamic message;
  dynamic response;

  NetworkResponse({this.hasError = false, this.message, this.response});
}
