import 'package:adr_finance_app/config/pallete.dart';
import 'package:adr_finance_app/page/login_signup.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adr_finance_app/services/auth.dart';
import 'package:get/get.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  Auth auth = Auth();
  final Uri _url = Uri.parse('https://financemonitor.adr-site.com/login');
  final storage = FlutterSecureStorage();
  String userName, userEmail, userPhoto = "X";
  bool _isLoading = true;

  void _launchUrl(context) async {
    Navigator.pop(context);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  void _logOut() async {
    await auth.logout();
    Get.offAll(
      LoginSignUpScreen(),
      transition: Transition.fadeIn,
      duration: Duration(
        seconds: 1,
      ),
    );
  }

  void getUserFromStorage() async {
    // _isLoading = true;
    userName = await storage.read(key: 'userName') ?? "X";
    userEmail = await storage.read(key: 'userEmail') ?? "X";
    userPhoto = await storage.read(key: 'userPhoto') ?? "X";
    setState(() {
      _isLoading = false;
    });
    print("Set Drawer ADR");
  }

  void selectedItem(BuildContext context, int index) {
    print(context);
  }

  @override
  void initState() {
    super.initState();
    getUserFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _isLoading
          ? Center(
              child: Text("Loading.."),
            )
          : Container(
              color: Pallete.greenTheme3,
              child: ListView(
                children: [
                  Container(
                    padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(userPhoto),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AboutDialog(
                                applicationIcon: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage("images/LOGO1.png"),
                                ),
                                applicationName: "ADR Fm",
                                applicationVersion: "Version 2.2",
                                children: [
                                  Text("ADR Finance Monitor Version 2.2 by Artono Dwi R")
                                ],
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Pallete.greenTheme2,
                            child:
                                Icon(Icons.info_outlined, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white70,
                  ),
                  // buildMenuItem(
                  //   text: "Home",
                  //   icon: Icons.home,
                  //   onCliked: () => selectedItem(context, 0),
                  // ),
                  buildMenuItem(
                    text: "Report",
                    icon: Icons.area_chart_rounded,
                    onCliked: () => _launchUrl(context),
                  ),
                  buildMenuItem(
                    text: "Profile (Coming Soon)",
                    icon: Icons.person,
                    onCliked: () => selectedItem(context, 1),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.white70,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildMenuItem(
                    text: "Logout",
                    icon: Icons.logout,
                    onCliked: () => _logOut(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildMenuItem({
    String text,
    IconData icon,
    VoidCallback onCliked,
  }) {
    final color = Colors.white;
    final hoverColors = Colors.white70;

    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      hoverColor: hoverColors,
      onTap: onCliked,
    );
  }
}
