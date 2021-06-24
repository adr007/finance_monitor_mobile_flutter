import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/services/data.dart';
import 'package:adr_finance_app/util/tools.dart';
import 'package:flutter/material.dart';
import 'package:adr_finance_app/util/color_icon_util.dart';

class DashboardMain extends StatefulWidget {
  @override
  _DashboardMainState createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  String token = null;
  Data data = Data();
  Map<String, dynamic> summaryData;
  Map<String, dynamic> userData;
  String user = "";
  bool _isLoading = true;
  bool _isVisible = false;
  List asetData;

  // Text buildTextLoadingStatus() {
  //   return Text(
  //     ".........",
  //     style: TextStyle(
  //       color: Colors.white,
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    summaryData = await data.getSumarry();
    userData = await data.getUserData();
    // asetData = summaryData['detail'];

    asetData = summaryData['detail'];

    print("CETAK LIST ASET");

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/bg-anime2.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.9,
                  child: Container(
                    height: 330,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Pallete.greenTheme2, Pallete.greenTheme3],
                      ),
                      // color: Pallete.greenTheme3.withOpacity(0.85),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color(0xFF22BD9A),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 8,
                                      spreadRadius: 3,
                                    )
                                  ],
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: EdgeInsets.all(4),
                                child: CircleAvatar(
                                  backgroundImage: _isLoading
                                      ? AssetImage("images/bg-dark.png")
                                      : NetworkImage(userData['user_photo']),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isLoading
                                        ? "........."
                                        : userData['user_name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.camera_front,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RichText(
                                          text: TextSpan(
                                        text: _isLoading
                                            ? "........"
                                            : _isVisible
                                                ? Tools.currency(int.parse(
                                                    summaryData['totalAssets']))
                                                : "*****************",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300),
                                      )),
                                      IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isVisible = !_isVisible;
                                            });
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                // color: Pallete.backgroundColorDarkMode.withOpacity(0.9),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Bg1.png"),
                    fit: BoxFit.cover,
                  ),
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Pallete.backgroundColorDarkMode,
                  //     Pallete.backgroundSoftColorDarkMode
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                ),
                child: _isLoading
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Center(
                          child: Text(
                            "Loading .. ..",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.only(top: 60),
                        children: [
                          Text(
                            "Distributed Assets ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          for (var i in asetData)
                            buildPortfolioCard(
                                ColorIconUtil.getIcon(i['icon'].toString()),
                                i['assetName'],
                                int.parse(i['amount'].toString()),
                                80,
                                ColorIconUtil.getColor(i['color'].toString())),
                          SizedBox(height: 60),
                          // buildPortfolioCard(Icons.business_center_sharp, "Stock",
                          //     10000000, 50, Colors.teal),
                          // buildPortfolioCard(Icons.layers, "Bank Savings", 10000000,
                          //     50, Colors.lightBlue),
                          // buildPortfolioCard(Icons.attach_money, "Cash", 10000000, 50,
                          //     Pallete.greenTheme1),
                        ],
                      ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 215,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            width: MediaQuery.of(context).size.width * 0.85,
            height: 160,
            decoration: BoxDecoration(
              color: Pallete.backgroundSoftColorDarkMode,
              boxShadow: [
                BoxShadow(
                  color: Pallete.greenTheme2.withOpacity(.2),
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Income",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_upward,
                              color: Color(0xFF00838F),
                            )
                          ],
                        ),
                        Text(
                          "Rp. 90.000.000",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Expenses",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.redAccent,
                            )
                          ],
                        ),
                        Text(
                          "Rp. 10.000.000",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Your spent Rp. 15.000.000 this month",
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  "Let's see the cost statistics for this period",
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Tell me more",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Pallete.greenTheme1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container buildPortfolioCard(
      IconData icon, String title, int amount, int percent, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Pallete.backgroundSoftColorDarkMode.withOpacity(0.9),
        // border: Border(
        //   left: BorderSide(width: 1.5, color: color),
        // ),
      ),
      height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(.3),
                      blurRadius: 3,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      Tools.currency(amount),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Stack(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.shade300,
                ),
              ),
              Container(
                height: 3,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//   Container buildActivityButton(
//       IconData icon, String title, Color bgColor, Color iconColor) {
//     return Container(
//       margin: EdgeInsets.all(10),
//       height: 90,
//       width: 90,
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: iconColor,
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Text(
//             title,
//             style:
//                 TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
//           )
//         ],
//       ),
//     );
//   }
}
