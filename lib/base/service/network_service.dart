import 'dart:convert';
import 'package:adorn/base/model/network_response.dart';
import 'package:adorn/base/service/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class NetworkService {
  Dio? _dio;

  static final NetworkService _networkController = NetworkService._();

  factory NetworkService() => _networkController;

  String Function(int errorCode)? processError;

  NetworkService._() {
    _dio = Dio();
  }

  resetToken() {
    _dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'allowWithoutToken': true
    };
  }

  updateToken({required String token, TokenType type = TokenType.bearer}) {
    _dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '${type == TokenType.none ? "" : "Bearer "}$token',
    };
  }

  Future<NetworkResponse> post(String endPoint, {
    Map<String, dynamic>? requestData,
    RequestType requestType = RequestType.formData,
    Function(Map<String, dynamic>)? responseCompiler,
    Function(NetworkResponse)? onCacheRetrieve,
  }) async {
    _printEndPointAndRequest(requestData, endPoint);

    _processCache(onCacheRetrieve, endPoint, responseCompiler);

    NetworkResponse networkResponse = await _apiResponseProcessor(
      onApiRequest: () async {
        return await _dio?.post(
          endPoint,
          data: requestData == null
              ? null
              : requestType == RequestType.raw
              ? requestData
              : FormData.fromMap(requestData),
        );
      },
    );

    _compiledResponse(responseCompiler, networkResponse);

    ///Store response
    if (onCacheRetrieve != null && !networkResponse.hasError) {
      StorageService.save(key: endPoint, value: networkResponse.toJson());
    }
    return networkResponse;
  }

  Future<NetworkResponse> get(String endPoint, {
    Map<String, dynamic>? requestData,
    Function(Map<String, dynamic>)? responseCompiler,
    Function(NetworkResponse)? onCacheRetrieve,
  }) async {
    _printEndPointAndRequest(requestData, endPoint);

    _processCache(onCacheRetrieve, endPoint, responseCompiler);

    NetworkResponse networkResponse = await _apiResponseProcessor(
      onApiRequest: () async {
        return await _dio?.get(
          endPoint,
          queryParameters: requestData,
        );
      },
    );

    _compiledResponse(responseCompiler, networkResponse);


    ///Store response
    if (onCacheRetrieve != null && !networkResponse.hasError) {
      StorageService.save(key: endPoint, value: networkResponse.toJson());
    }

    return networkResponse;
  }

  Stream<NetworkResponse> advancedPost(String endPoint, {
    Map<String, dynamic>? requestData,
    RequestType requestType = RequestType.formData,
    Function(Map<String, dynamic>)? responseCompiler,
    bool supportCatching = false,
  }) async* {
    NetworkResponse networkResponse;

    ///This part will get stored response and return that
    if (supportCatching) {
      NetworkResponse? networkResponse =
      await _getCachedResponse(endPoint, responseCompiler);
      if (networkResponse != null && !networkResponse.hasError) {
        yield networkResponse;
      }
    }

    networkResponse = await post(endPoint,
        requestData: requestData, requestType: requestType);

    ///Store response
    if (supportCatching && !networkResponse.hasError) {
      StorageService.save(key: endPoint, value: networkResponse.toJson());
    }

    _compiledResponse(responseCompiler, networkResponse);
    yield networkResponse;
  }

  Stream<NetworkResponse> advancedGet(String endPoint, {
    Map<String, dynamic>? requestData,
    Function(Map<String, dynamic>)? responseCompiler,
    bool supportCatching = false,
  }) async* {
    NetworkResponse networkResponse;

    ///This part will get stored response and return that
    if (supportCatching) {
      NetworkResponse? networkResponse =
      await _getCachedResponse(endPoint, responseCompiler);
      if (networkResponse != null && !networkResponse.hasError) {
        yield networkResponse;
      }
    }

    networkResponse = await get(endPoint, requestData: requestData);

    ///Store response
    if (supportCatching && !networkResponse.hasError) {
      StorageService.save(key: endPoint, value: networkResponse.toJson());
    }

    _compiledResponse(responseCompiler, networkResponse);
    yield networkResponse;
  }

  Future<void> _processCache(Function(NetworkResponse)? onCacheRetrieve,
      String endPoint,
      Function(Map<String, dynamic>)? responseCompiler,) async {
    if (onCacheRetrieve != null) {
      NetworkResponse? response =
      await _getCachedResponse(endPoint, responseCompiler);
      if (response != null) {
        onCacheRetrieve(response);
      }
    }
  }

  Future<NetworkResponse?> _getCachedResponse(String endPoint,
      Function(Map<String, dynamic>)? responseCompiler,) async {
    NetworkResponse? networkResponse;
    String? storedResponse = await StorageService.get(key: endPoint);
    if (storedResponse != null) {
      networkResponse =
          NetworkResponse.fromJson(json: jsonDecode(storedResponse));
      _compiledResponse(responseCompiler, networkResponse);
    }
    return networkResponse;
  }

  void _compiledResponse(Function(Map<String, dynamic>)? responseCompiler,
      NetworkResponse networkResponse,) {
    try {
      if (responseCompiler != null) {
        if (networkResponse.response is Map) {
          networkResponse.response = responseCompiler(networkResponse.response);
        } else {
          networkResponse.response = responseCompiler(
            jsonDecode(networkResponse.response),
          );
        }
      }
    } catch (error) {
      networkResponse.hasError = true;
      networkResponse.message = processError != null
          ? processError!(NetworkErrors.dataFormatError)
          : "Data format mismatch";
    }
  }

  void _printEndPointAndRequest(Map<String, dynamic>? requestData,
      String endPoint,) {
    if (kDebugMode) {
      print(requestData);
      print(endPoint);
    }
  }

  Future<NetworkResponse> _apiResponseProcessor({
    required Future<Response?> Function() onApiRequest,
  }) async {
    Response? resp;
    NetworkResponse response = NetworkResponse();
    try {
      resp = await onApiRequest();
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
    if (kDebugMode) log(resp?.data?.toString() ?? '');

    response.response = resp?.data;

    return response;
  }

  _processErrors(DioError error, NetworkResponse response) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        response.message = processError != null
            ? processError!(NetworkErrors.connectTimeout)
            : 'Connection Timeout';
        break;
      case DioErrorType.sendTimeout:
        response.message = processError != null
            ? processError!(NetworkErrors.sendTimeout)
            : 'Send timeout';
        break;
      case DioErrorType.receiveTimeout:
        response.message = processError != null
            ? processError!(NetworkErrors.receiveTimeout)
            : 'Receive timeout';
        break;
      case DioErrorType.response:
        if (kDebugMode) {
          log(error.response?.data?.toString() ?? "");
        }
        response.message = processError != null
            ? processError!(NetworkErrors.response)
            : 'Error processing request';
        response.response = error.response?.data;
        break;
      case DioErrorType.cancel:
        response.message = processError != null
            ? processError!(NetworkErrors.cancel)
            : 'Request canceled';
        break;
      default:
        response.message = processError != null
            ? processError!(NetworkErrors.other)
            : 'Error api response';
        break;
    }
  }
}

enum RequestType { formData, raw }

enum TokenType { bearer, none }

abstract class NetworkErrors {
  static int dataFormatError = 1;
  static int receiveTimeout = 2;
  static int connectTimeout = 3;
  static int sendTimeout = 4;
  static int response = 5;
  static int cancel = 6;
  static int other = 7;
  static int none = 0;
}
