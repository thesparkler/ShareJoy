import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/meme_icons.dart';
import 'package:ShareJoy/screens/memes_screen.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'home_screen.dart';

class HomePage extends StatefulWidget {
  final type;
  final Map<String, dynamic> filter;

  const HomePage({Key key, this.type, this.filter}) : super(key: key);
  static void route(
      BuildContext context, String type, Map<String, dynamic> filter) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  type: type,
                  filter: filter,
                )),
        (route) => false);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  Map<String, dynamic> filter = {};
  @override
  void initState() {
    currentTab = widget.type == "meme"
        ? 1
        : widget.type == "shayari"
            ? 2
            : widget.type == "greetings"
                ? 3
                : 0;
    if (widget.filter != null) filter = widget.filter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: DetailView(
          currentTab: currentTab,
          filter: filter,
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black, blurRadius: 2)
          ]),
          child: BottomNavigationBar(
            elevation: 10.0,
            backgroundColor: Colors.white,
            onTap: (v) async {
              setState(() {
                filter = {};
                currentTab = v;
              });
              var tabName = "";
              switch (v) {
                case 0:
                  tabName = "home";
                  break;
                case 1:
                  tabName = "memes";
                  break;
                case 2:
                  tabName = "shayari";
                  break;
                case 3:
                  tabName = "status";
                  break;
                case 4:
                  tabName = "setting";
              }
              await FirebaseAnalytics()
                  .logEvent(name: "tab_clicked", parameters: {
                "name": tabName,
              });
              print("$tabName tab clicked");
            },
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: TextStyle(color: Colors.black),
            currentIndex: currentTab,
            items: [
              BottomNavigationBarItem(
                icon: Icon(MdiIcons.home),
                title: Text(
                  "Home",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(MdiIcons.ghost),
                title: Text(
                  "Memes",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                ),
              ),
              BottomNavigationBarItem(
                icon: Center(
                  child: Icon(
                    MdiIcons.feather,
                  ),
                ),
                title: Center(
                    child: Text(
                  "Shayari",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                )),
              ),
              BottomNavigationBarItem(
                icon: Icon(Meme.greetings),
                title: Text(
                  "Status",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                ),
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(MdiIcons.cog),
              //   title: Text(
              //     "Settings",
              //     style: TextStyle(fontFamily: 'RobotoMedium'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final int currentTab;
  final Map filter;

  const DetailView({Key key, this.currentTab, this.filter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (currentTab) {
      case 0:
        return HomeScreen();
      case 1:
      case 2:
      case 3:
        return MemesScreen(type: Config.types[currentTab], filter: filter);
      // case 4:
      //   return SettingScreen();
    }
    return CustomTheme.placeHolder;
  }
}
