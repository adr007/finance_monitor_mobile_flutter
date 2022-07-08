import 'package:adr_finance_app/page/home_page.dart';
import 'package:adr_finance_app/page/login_signup.dart';
import 'package:adr_finance_app/services/auth.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

Auth auth = Auth();

Future<void> _logOut() async {
  await auth.forceLogout();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var jsonUser = await Data().getUserData();

  print("TESS ADR");
  print(jsonUser);

  if (jsonUser == null) {
    _logOut();
  }

  final storage = new FlutterSecureStorage();
  String _token = await storage.read(key: 'token') ?? null;

  // print("TESS Token");
  // print(_token);

  // print("TOKEN from MAIN");
  // print(_token);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "ADR Finance Monitor",
    home: _token == null ? LoginSignUpScreen() : HomePage(),
  ));
}

