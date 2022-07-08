import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/page/convert_page.dart';
import 'package:adr_finance_app/page/dashboard.dart';
import 'package:adr_finance_app/page/form_trans.dart';
// import 'package:adr_finance_app/page/login_signup.dart';
// import 'package:adr_finance_app/page/login_signup.dart';
import 'package:adr_finance_app/page/profile.dart';
import 'package:adr_finance_app/page/transaction.dart';
import 'package:adr_finance_app/page/asset_page.dart';
// import 'package:adr_finance_app/services/auth.dart';
import 'package:adr_finance_app/util/navigation_drawer_widget.dart';
// import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:spincircle_bottom_bar/modals.dart';
import 'package:spincircle_bottom_bar/spincircle_bottom_bar.dart';
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
  // Auth auth = Auth();

  List<Widget> _pageBody = [
    DashboardMain(),
    AssetPage(),
    Transaction(),
    Profile(),
  ];

  // void _logOut() async {
  //   await auth.logout();
  //   Get.offAll(
  //     LoginSignUpScreen(),
  //     transition: Transition.fadeIn,
  //     duration: Duration(
  //       seconds: 1,
  //     ),
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      drawer: NavigationDrawerWidget(),
      // key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Finance Monitor",
          style: TextStyle(fontFamily: "SpaceAge", fontSize: 21),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          },
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        //   onPressed: () => Scaffold.of(context).openDrawer(),
        // ),
        actions: [
          // IconButton(icon: Icon(Icons.logout), onPressed: _logOut),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     String res = await Get.to<String>(
      //       () => FormTrans(),
      //       transition: Transition.upToDown,
      //     );
      //     if (res == "isFromTransPage") {
      //       // transController.refresh();
      //     }
      //   },
      //   // backgroundColor: Pallete.greenTheme1,
      //   child: Container(
      //     height: 60,
      //     width: 60,
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       gradient: LinearGradient(
      //         colors: [
      //           Pallete.linerUp1,
      //           Pallete.linearDown1,
      //         ],
      //       ),
      //     ),
      //     child: Icon(
      //       Icons.add_to_photos_rounded,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // bottomNavigationBar: BubbleBottomBar(
      //   opacity: 0.2,
      //   backgroundColor: Pallete.backgroundColor,
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      //   currentIndex: _selectedItemIndex,
      //   hasInk: true,
      //   inkColor: Colors.grey,
      //   hasNotch: true,
      //   fabLocation: BubbleBottomBarFabLocation.end,
      //   onTap: _changePage,
      //   items: [
      //     buildBubbleBottomBarItem(
      //         Icons.dashboard, "Dashboard", Colors.grey, Pallete.greenTheme1),
      //     buildBubbleBottomBarItem(Icons.card_giftcard_outlined, "Assets",
      //         Colors.grey, Pallete.greenTheme1),
      //     buildBubbleBottomBarItem(
      //         Icons.repeat, "Transaction", Colors.grey, Pallete.greenTheme1),
      //     buildBubbleBottomBarItem(
      //         Icons.person, "Profile", Colors.grey, Pallete.greenTheme1),
      //   ],
      // ),
      // body: _pageBody[_selectedItemIndex],
      body: SpinCircleBottomBarHolder(
        bottomNavigationBar: SCBottomBarDetails(
            iconTheme: IconThemeData(color: Colors.black45),
            activeIconTheme: IconThemeData(color: Pallete.greenTheme2),
            // titleStyle: TextStyle(color: Colors.black45, fontSize: 12),
            // activeTitleStyle: TextStyle(color: Colors.orange, fontSize: 12),
            bnbHeight: 70,
            backgroundColor: Colors.white,
            circleColors: [Colors.white, Pallete.linerUp1, Pallete.greenTheme2],
            actionButtonDetails: SCActionButtonDetails(
              color: Pallete.greenTheme2,
              icon: Icon(Icons.add_moderator_outlined),
              elevation: 0,
            ),
            items: [
              SCBottomBarItem(
                  icon: Icons.dashboard,
                  onPressed: () {
                    _changePage(0);
                  }),
              SCBottomBarItem(
                  icon: Icons.card_giftcard_outlined,
                  onPressed: () {
                    _changePage(1);
                  }),
              SCBottomBarItem(
                  icon: Icons.repeat,
                  onPressed: () {
                    _changePage(2);
                  }),
              SCBottomBarItem(
                  icon: Icons.person,
                  onPressed: () {
                    _changePage(3);
                  }),
            ],
            circleItems: [
              SCItem(
                icon: Icon(Icons.add_shopping_cart, color: Pallete.linerUp1),
                onPressed: () async {
                  String res = await Get.to<String>(
                    () => FormTrans(),
                    transition: Transition.upToDown,
                  );
                  if (res == "isFromTransPage") {
                    // transController.refresh();
                  }
                },
              ),
              SCItem(
                icon: Icon(Icons.post_add_outlined, color: Pallete.greenTheme2),
                onPressed: () async {
                  String res = await Get.to<String>(
                    () => ConvertPage(),
                    transition: Transition.upToDown,
                  );
                  if (res == "isFromTransPage") {
                    // transController.refresh();
                  }
                },
              ),
            ]),
        child: _pageBody[_selectedItemIndex],
      ),
    );
  }

  // BubbleBottomBarItem buildBubbleBottomBarItem(
  //     IconData icon, String title, Color iconColor, Color bgColor) {
  //   return BubbleBottomBarItem(
  //     icon: Icon(
  //       icon,
  //       color: iconColor,
  //     ),
  //     activeIcon: Icon(
  //       icon,
  //       color: Colors.green,
  //     ),
  //     backgroundColor: bgColor,
  //     title: Text(title),
  //   );
  // }

}
