

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHandler {
  final Dio dio ;

DioHandler() : dio = Dio(
BaseOptions(
  baseUrl: 'https://api.escuelajs.co/api/v1/products' ,
  connectTimeout: Duration(seconds: 5000),
  receiveTimeout: Duration(seconds: 3000),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }
  )
) {
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ));
}
}