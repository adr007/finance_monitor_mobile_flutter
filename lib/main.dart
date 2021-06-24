import 'package:adr_finance_app/page/home_page.dart';
import 'package:adr_finance_app/page/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = new FlutterSecureStorage();
  String _token = await storage.read(key: 'token') ?? null;
  // print("TOKEN from MAIN");
  // print(_token);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "ADR Finance Monitor",
    home: _token == null ? LoginSignUpScreen() : HomePage(),
  ));
}

// class MyApp extends StatefulWidget {
//   MyApp(MaterialApp materialApp);
//
//   // const MyApp({Key key}) : super(key: key);
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }
//
//   checkLoginStatus() async {
//     _token = print("TOKEN");
//     print(_token);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Login SignUp UI",
//       home: _token != null ? HomePage() : LoginSignUpScreen(),
//     );
//   }
// }
