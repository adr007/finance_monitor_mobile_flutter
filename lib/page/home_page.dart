import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/page/dashboard.dart';
import 'package:adr_finance_app/page/form_trans.dart';
import 'package:adr_finance_app/page/login_signup.dart';
import 'package:adr_finance_app/page/profile.dart';
import 'package:adr_finance_app/page/transaction.dart';
import 'package:adr_finance_app/page/asset_page.dart';
import 'package:adr_finance_app/services/auth.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final int defaultSelectedIndex;

  HomePage({this.defaultSelectedIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItemIndex;
  Auth auth = Auth();

  List<Widget> _pageBody = [
    DashboardMain(),
    AssetPage(),
    Transaction(),
    Profile(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedItemIndex = widget.defaultSelectedIndex;
  }

  void _changePage(int index) {
    setState(() {
      _selectedItemIndex = index;
    });
  }

  void _logOut() async {
    await auth.logout();
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    //   return LoginSignUpScreen();
    // }));
    Get.offAll(LoginSignUpScreen(),
        transition: Transition.fadeIn, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(
          "Finance Monitor",
          style: TextStyle(fontFamily: "SpaceAge", fontSize: 21),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logOut),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String res = await Get.to<String>(
            () => FormTrans(),
            transition: Transition.upToDown,
          );
          if (res == "isFromTransPage") {
            // transController.refresh();
          }
        },
        // backgroundColor: Pallete.greenTheme1,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Pallete.greenTheme2,
                Pallete.greenTheme3,
              ],
            ),
          ),
          child: Icon(
            Icons.add_to_photos_rounded,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.2,
        backgroundColor: Pallete.backgroundColorDarkMode,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        currentIndex: _selectedItemIndex,
        hasInk: true,
        inkColor: Colors.black12,
        hasNotch: true,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: _changePage,
        items: [
          buildBubbleBottomBarItem(
              Icons.dashboard, "Dashboard", Colors.grey, Pallete.greenTheme1),
          buildBubbleBottomBarItem(Icons.card_giftcard_outlined, "Assets",
              Colors.grey, Pallete.greenTheme1),
          buildBubbleBottomBarItem(
              Icons.repeat, "Transaction", Colors.grey, Pallete.greenTheme1),
          buildBubbleBottomBarItem(
              Icons.person, "Profile", Colors.grey, Pallete.greenTheme1),
        ],
      ),
      body: _pageBody[_selectedItemIndex],
    );
  }

  BubbleBottomBarItem buildBubbleBottomBarItem(
      IconData icon, String title, Color iconColor, Color bgColor) {
    return BubbleBottomBarItem(
      icon: Icon(
        icon,
        color: iconColor,
      ),
      activeIcon: Icon(
        icon,
        color: Colors.white,
      ),
      backgroundColor: bgColor,
      title: Text(title),
    );
  }

  // Row(
  // children: [
  // buildNavbarItem(Icons.home, 0),
  // buildNavbarItem(Icons.card_giftcard, 1),
  // buildNavbarItem(Icons.camera, 2),
  // buildNavbarItem(Icons.pie_chart, 3),
  // buildNavbarItem(Icons.person, 4),
  // ],
  // ),

  // GestureDetector buildNavbarItem(IconData icon, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedItemIndex = index;
  //       });
  //     },
  //     child: Container(
  //       width: MediaQuery.of(context).size.width / 5,
  //       height: 60,
  //       decoration: index == selectedItemIndex
  //           ? BoxDecoration(
  //               border: Border(
  //                 bottom: BorderSide(
  //                   width: 4,
  //                   color: Colors.green,
  //                 ),
  //               ),
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Colors.green.withOpacity(0.3),
  //                   Colors.green.withOpacity(0.016),
  //                 ],
  //                 begin: Alignment.bottomCenter,
  //                 end: Alignment.topCenter,
  //               ),
  //             )
  //           : BoxDecoration(),
  //       child: Icon(
  //         icon,
  //         color: index == selectedItemIndex ? Color(0XFF00B668) : Colors.grey,
  //       ),
  //     ),
  //   );
  // }
}
