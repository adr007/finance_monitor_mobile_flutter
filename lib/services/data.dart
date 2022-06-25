// import 'dart:convert';

import 'package:adr_finance_app/services/api.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:adr_finance_app/models/sub_asset.dart';

class Data {
  final storage = FlutterSecureStorage();

  Future<Object> getSumarry() async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/sub-asset/summary', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data['data'];
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Object> getUserData() async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/user/get', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data['data'];
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getSubAsset() async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/sub-asset/get-by-user', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data['data'];
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getAssetsList() async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/asset/get-list', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data['data'];
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> saveAsset({isAdd = true, creds}) async {
    String token = await storage.read(key: 'token') ?? "";
    String link = "/sub-asset/create";
    if (!isAdd) {
      link = "/sub-asset/update";
    }
    try {
      Dio.Response response = await api().post(link, data: creds, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data;
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> getAssetDetail({creds}) async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/sub-asset/get', data: creds, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data;
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteAsset({creds}) async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/sub-asset/delete', data: creds, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data;
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getTransaction() async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/transaction/get-by-user', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data['data'];
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> saveTransaction({creds}) async {
    String token = await storage.read(key: 'token') ?? "";
    String link = "/transaction/create";
    // if (!isAdd) {
    //   link = "/sub-asset/update";
    // }
    try {
      Dio.Response response = await api().post(link, data: creds, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      // print(response);
      return response.data;
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteTransaction({creds}) async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/transaction/delete', data: creds, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data;
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> doConvert({creds}) async {
    String token = await storage.read(key: 'token') ?? "";
    String link = "/sub-asset/convert";
    try {
      Dio.Response response = await api().post(link, data: creds, options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      // print(response);
      return response.data;
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getAllTag() async {
    String token = await storage.read(key: 'token') ?? "";
    try {
      Dio.Response response = await api().post('/tag/getAll', options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      // print(json.decode(response.data.toString()));
      return response.data['data'];
    } catch(e){
      print("ERRROR");
      print(e);
      return null;
    }
  }

}