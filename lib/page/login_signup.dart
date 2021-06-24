import 'package:adr_finance_app/page/home_page.dart';
import 'package:adr_finance_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:adr_finance_app/config/pallete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginSignUpScreen extends StatefulWidget {
  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  Auth auth = new Auth();
  bool isMale = true;
  bool isSignUpScreen = true;
  bool isRememberMe = false;
  bool _isLoading = false;
  String _token;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  void _gasLogin () async {
    Map creds = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    if (_formKey.currentState.validate()) {
      await storage.deleteAll();
      await auth.login(context, creds);
      _token = await storage.read(key: 'token') ?? null;
      print(_token);
      if (_token != null) {
        Get.off(HomePage(), transition: Transition.cupertino, duration: Duration(seconds: 1));
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) {
        //       return HomePage();
        //     }));
      } else {
        print("Login failed");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("TEss"),),
      backgroundColor: Pallete.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xFF000000), Color(0xff1c2c50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/bg1.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 90, left: 20),
                    color: Color(0xFF3b5999).withOpacity(.85),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                              text: "Welcome ",
                              style: TextStyle(
                                fontSize: 25,
                                letterSpacing: 2,
                                color: Colors.yellow[700],
                              ),
                              children: [
                                TextSpan(
                                    text: isSignUpScreen
                                        ? "to ADR Finance"
                                        : "Back",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow[700],
                                    ))
                              ]),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          isSignUpScreen
                              ? "Signup to continue"
                              : "Login to continue",
                          style: TextStyle(
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            // buildBottomHalfContainer(true),
            // main container for login and signup
            AnimatedPositioned(
                duration: Duration(milliseconds: 700),
                curve: Curves.easeInCubic,
                top: isSignUpScreen ? 200 : 230,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInCubic,
                    height: isSignUpScreen ? 380 : 270,
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5),
                        ]),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignUpScreen = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignUpScreen
                                              ? Pallete.textColor1
                                              : Pallete.activeColor),
                                    ),
                                    if (!isSignUpScreen)
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: Colors.orange,
                                      ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignUpScreen = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "SIGNUP",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignUpScreen
                                              ? Pallete.activeColor
                                              : Pallete.textColor1),
                                    ),
                                    if (isSignUpScreen)
                                      Container(
                                        margin: EdgeInsets.only(top: 3),
                                        height: 2,
                                        width: 55,
                                        color: Colors.orange,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (isSignUpScreen) buildSignUpSection(),
                          if (!isSignUpScreen) buildLoginSection(),
                        ],
                      ),
                    ))),
            // submit button
            buildBottomHalfContainer(false),
            Positioned(
                top: MediaQuery.of(context).size.height - 100,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    Text(
                      isSignUpScreen ? "or Signup with" : "or Login with",
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildTextButton(MaterialCommunityIcons.facebook,
                              "Facebook", Pallete.facebookColor),
                          buildTextButton(MaterialCommunityIcons.google,
                              "Google", Pallete.googleColor)
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Container buildLoginSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextField(Icons.mail_outline, "example@gg.com", false,
                    true, _emailController),
                buildTextField(MaterialCommunityIcons.lock_outline,
                    "**********", true, false, _passwordController),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                      value: isRememberMe,
                      activeColor: Pallete.textColor2,
                      onChanged: (value) {
                        setState(() {
                          isRememberMe = !isRememberMe;
                        });
                      }),
                  Text(
                    "Remember me",
                    style: TextStyle(fontSize: 12, color: Pallete.textColor1),
                  ),
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot password",
                    style: TextStyle(fontSize: 12, color: Colors.orangeAccent),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Container buildSignUpSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(MaterialCommunityIcons.account_outline, "User Name",
              false, false, _userNameController),
          buildTextField(MaterialCommunityIcons.email_outline, "Email", false,
              true, _emailController),
          buildTextField(MaterialCommunityIcons.lock_outline, "Password", true,
              false, _passwordController),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              isMale ? Pallete.textColor2 : Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color:
                                isMale ? Pallete.textColor2 : Pallete.iconColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Colors.white : Pallete.iconColor,
                        ),
                      ),
                      Text(
                        "Male",
                        style: TextStyle(
                          color: Pallete.textColor1,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color:
                              !isMale ? Pallete.textColor2 : Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: isMale
                                ? Pallete.textColor2
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: !isMale ? Colors.white : Pallete.iconColor,
                        ),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(
                          color: Pallete.textColor1,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By pressing 'Submit' you agree to out ",
                  style: TextStyle(color: Pallete.textColor2),
                  children: [
                    TextSpan(
                      text: "term & conditions",
                      style: TextStyle(color: Colors.orange),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor,
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 5,
            ),
            Text(title)
          ],
        ));
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInCubic,
        top: isSignUpScreen ? 535 : 455,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            height: 90,
            width: 90,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                _gasLogin();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[200], Colors.red[400]],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    if (showShadow)
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 1),
                      )
                  ],
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController textControl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: textControl,
        validator: (value) => value.isEmpty ? "Must be filled" : null,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Pallete.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Pallete.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Pallete.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Pallete.textColor1,
          ),
          contentPadding: EdgeInsets.all(12),
        ),
      ),
    );
  }
}
