import 'package:Meme/config.dart';
import 'package:Meme/meme_icons.dart';
import 'package:Meme/screens/memes_screen.dart';
import 'package:Meme/screens/setting_screen.dart';
import 'package:Meme/theme_data.dart';
// import 'package:flat_icons_flutter/flat_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: DetailView(
          currentTab: currentTab,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (v) {
          setState(() {
            currentTab = v;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: TextStyle(color: Colors.black),
        currentIndex: currentTab,
        items: [
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
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.cog),
            title: Text(
              "Settings",
              style: TextStyle(fontFamily: 'RobotoMedium'),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final int currentTab;

  const DetailView({Key key, this.currentTab}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (currentTab) {
      case 0:
      case 1:
      case 2:
        return MemesScreen(type: Config.types[currentTab]);
      case 3:
        return SettingScreen();
    }
    return CustomTheme.placeHolder;
  }
}
