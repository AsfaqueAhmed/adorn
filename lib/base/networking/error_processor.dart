import 'package:dio/dio.dart';

///base class for api response error processing
abstract class NetworkErrorProcessor {
  /// returns error message. message type is dynamic (such as string or map)
  dynamic onConnectionTimeout();

  /// returns error message. message type is dynamic (such as string or map)
  dynamic onSendTimeout();

  /// returns error message. message type is dynamic (such as string or map)
  dynamic onReceiveTimeout();

  /// returns error message. message type is dynamic (such as string or map)
  dynamic onCancel();

  /// returns error message. message type is dynamic (such as string or map)
  dynamic onOtherError();

  /// returns error message. message type is dynamic (such as string or map)
  dynamic onResponseError(int? statusCode, Response<dynamic>? response);
}
