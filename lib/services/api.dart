import 'package:dio/dio.dart';

Dio api() {
  Dio dio = new Dio();
  dio.options.baseUrl = "http://financemonitor.adr-site.com/api";
  dio.options.headers['accept'] = 'Application/Json';
  return dio;
}