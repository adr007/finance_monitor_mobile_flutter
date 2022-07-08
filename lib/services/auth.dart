import 'package:adr_finance_app/services/api.dart';
import 'package:adr_finance_app/util/dialog_auth.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  // bool _isLogin = false;
  // User _user;
  // String _token;
  //
  // bool get authenticated => _isLogin;
  // User get user =>  _user;

  final storage = new FlutterSecureStorage();

  Future<void> regis (BuildContext context, Map creds) async {
    try {
      Dio.Response response = await api().post('/register', data: creds);

      if (response.data['status']) {
        String token = response.data['token'].toString();
        String userId = response.data['user']['user_id'].toString();
        this.storage.write(key: 'token', value: token);
        this.storage.write(key: 'userId', value: userId);
        this.storage.write(key: 'userName', value: response.data['user']['user_name'].toString());
        this.storage.write(key: 'userEmail', value: response.data['user']['user_email'].toString());
        this.storage.write(key: 'userPhoto', value: response.data['user']['user_photo'].toString());
      }
      else {
        String msg = response.data['msg'].toString();
        DialogAuth.show(context, msg);
      }

      // return false;
    } catch (e) {
      DialogAuth.show(context, "System Error");
      print(e);
      // return false;
    }
  }

  Future<void> login (BuildContext context, Map creds) async {
    try {
      Dio.Response response = await api().post('/login', data: creds);

      if (response.data['status']) {
        String token = response.data['token'].toString();
        String userId = response.data['user']['user_id'].toString();
        this.storage.write(key: 'token', value: token);
        this.storage.write(key: 'userId', value: userId);
        this.storage.write(key: 'userName', value: response.data['user']['user_name'].toString());
        this.storage.write(key: 'userEmail', value: response.data['user']['user_email'].toString());
        this.storage.write(key: 'userPhoto', value: response.data['user']['user_photo'].toString());
      }
      else {
        String msg = response.data['msg'].toString();
        DialogAuth.show(context, msg);
      }

      // return false;
    } catch (e) {
      DialogAuth.show(context, "System Error");
      print(e);
      // return false;
    }
  }

  Future<void> logout () async {
    String _token = await storage.read(key: 'token');
    try {
      await api().post('/logout', options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      print("Proses Log out selesai");
      cleanUp();
      print("proses clean up selesai");
      // notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> forceLogout () async {
    try {
      await api().post('/force-logout');
      print("Proses Log out selesai");
      cleanUp();
      print("proses clean up selesai");
      // notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> cleanUp() async {
    await storage.deleteAll();
  }


}