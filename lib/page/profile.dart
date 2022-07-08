import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/services/data.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Data data = Data();
  Map<String, dynamic> userData;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    userData = await data.getUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/blur1.jpg"),
            fit: BoxFit.cover,
          ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 130),
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Color(0xFF22BD9A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(.3),
                    blurRadius: 8,
                    spreadRadius: 3,
                  )
                ],
                borderRadius: BorderRadius.circular(85),
              ),
              padding: EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: _isLoading
                    ? AssetImage("images/bg-dark.png")
                    : NetworkImage(userData['user_photo']),
              ),
            ),
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                _isLoading ? "........." : userData['user_name'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "SpaceAge",
                ),
              ),
              SizedBox(height: 8),
              Text(
                _isLoading ? "........." : userData['user_email'],
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            height: 150,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 65,
                    width: 290,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 190,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  left: -25,
                  child: Container(
                    width: 50,
                    height: 190,
                    decoration: BoxDecoration(
                      color: Pallete.greenTheme1,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -25,
                  child: Container(
                    width: 50,
                    height: 190,
                    decoration: BoxDecoration(
                      color: Pallete.greenTheme2,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
