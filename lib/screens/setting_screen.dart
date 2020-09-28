import 'dart:ui';

import 'package:ShareJoy/theme_data.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../NoGlowBehaviour.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ShareJoy",
                  style: Theme.of(context).textTheme.headline5,
                ),
                CustomTheme.h24,
                Container(
                    height: 120,
                    width: 120,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          image: new AssetImage("assets/images/icon.png"),
                          fit: BoxFit.fill,
                        ))),
                CustomTheme.h12,
                Text(
                  "version 1.0.0",
                  style: TextStyle(fontFamily: 'RobotoRegular'),
                ),
              ],
            )),
        Expanded(
            child: ScrollConfiguration(
          behavior: NoGlowBehaviour(),
          child: ListView(
            children: [
              Divider(),
              ListTile(
                onTap: () => Share.text(
                    "Share App",
                    '''ShareJoy
                            Find the large collection of memes,shayari and status on the application.
                            Download app using following link:https://play.google.com/store/apps/details?id=com.app.sharejoy
                            ''',
                    "text/plain"),
                title: Text(
                  "Share App",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                ),
                subtitle: Text(
                  "Share your love by sharing the application to your friends",
                  style: TextStyle(fontFamily: 'RobotoRegular', fontSize: 14),
                ),
                trailing: Icon(MdiIcons.shareOutline),
              ),
              Divider(),
              ListTile(
                onTap: () => launch(
                    "https://play.google.com/store/apps/details?id=com.app.sharejoy"),
                title: Text(
                  "Rate our App",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                ),
                subtitle: Text(
                  "Please let us know your experience.",
                  style: TextStyle(fontFamily: 'RobotoRegular', fontSize: 14),
                ),
                trailing: Icon(MdiIcons.starOutline),
              ),
              Divider(),
            ],
          ),
        ))
      ],
    );
  }
}

// class NoGlowBehaviour extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }
