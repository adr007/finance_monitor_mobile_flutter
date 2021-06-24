import 'package:dio/dio.dart';

Dio api() {
  Dio dio = new Dio();
  dio.options.baseUrl = "http://192.168.43.68/api";
  dio.options.headers['accept'] = 'Application/Json';
  return dio;
}