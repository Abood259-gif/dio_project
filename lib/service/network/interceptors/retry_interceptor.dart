import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetryAttempts;
  final Duration retryDelay;
  final Dio dio;

  RetryInterceptor({
    required this.dio,
    this.maxRetryAttempts = 3,
    this.retryDelay = const Duration(seconds: 2),
  });
  static const String _retryKey = 'retry_attempts';
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
   int retryCount =  err.requestOptions.extra[_retryKey] ?? 0 ;
   if(_shouldRetry(err, retryCount)){  
    retryCount++;
    err.requestOptions.extra[_retryKey] = retryCount;
    await Future.delayed(retryDelay);
    try {
      final response = await dio.fetch(err.requestOptions);
    return   handler.resolve(response);
    } catch (e) {
     return handler.next(e as DioException);
    }
   }
     handler.next(err);
  }

bool _shouldRetry(DioException err, int retryCount) {
  final statusCode = err.response?.statusCode ?? 0;
    return retryCount < maxRetryAttempts &&
        (err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.receiveTimeout ||
            err.type == DioExceptionType.connectionError ||
           ( statusCode >= 500  )
            );
  }

}
