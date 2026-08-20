

import 'package:dio/dio.dart';
import 'package:dio_project/service/network/app_exception.dart';

class ErrorInterceptor extends Interceptor {

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
  
  

  final AppException appException = switch (err.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout =>  TimeoutException(),

    DioExceptionType.connectionError =>  NetworkExcption(),

    DioExceptionType.badResponse => _handleBadResponse(err.response),

    DioExceptionType.cancel =>  UnknownException(),

    DioExceptionType.badCertificate ||
    DioExceptionType.unknown =>  UnknownException(),
    DioExceptionType.transformTimeout => throw UnimplementedError(),
  };

  final customError = DioException(
    requestOptions: err.requestOptions,
    response: err.response,
    type: err.type,
    error: appException, 
    message: appException.message,
  );

  handler.next(customError);
  }

AppException _handleBadResponse(Response? response) {
  final statusCode = response?.statusCode;
  final serverMessage = response?.data?['message']?.toString();

  if (statusCode == 401 || statusCode == 403) {
    return UnauthorizedException();
  }

  return ServerException();
}

} 