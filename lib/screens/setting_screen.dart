import 'dart:ui';

import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/watermark_alert.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../NoGlowBehaviour.dart';

class SettingScreen extends StatelessWidget {
  static route(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ShareJoy",
                    style: TextStyle(
                        fontFamily: "FredokaOneRegular", fontSize: 25.0),
                    //style: Theme.of(context).textTheme.headline5,
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
                    "version 1.2.1",
                    style: TextStyle(fontFamily: 'RobotoRegular'),
                  ),
                ],
              )),
          Expanded(
              child: ScrollConfiguration(
            behavior: NoGlowBehaviour(),
            child: ListView(
              children: [
                ListTile(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      child: WatermarkAlert(onSubmit:
                          (String userWatermark, bool sharejoyWatermark) {
                        var prefs = {
                          "userWatermark": userWatermark,
                          "sharejoyWatermark": sharejoyWatermark
                        };
                        LocalStorage.instance.put("watermark_prefs", prefs);
                      }),
                    );
                  },
                  title: Text(
                    "Watermark Settings",
                    style: TextStyle(fontFamily: 'RobotoMedium'),
                  ),
                  subtitle: Text(
                    "Here you can change watermark settings",
                    style: const TextStyle(
                        fontFamily: 'RobotoRegular', fontSize: 14),
                  ),
                  trailing: Icon(MdiIcons.watermark),
                ),
                Divider(),
                ListTile(
                  onTap: () async {
                    await FirebaseAnalytics().logEvent(
                      name: "app_share_click",
                    );

                    Share.text(
                        "Share App",
                        '''Want to enjoy & share latest memes, shayari and status?
   
Download ShareJoy App Now!
https://play.google.com/store/apps/details?id=com.app.sharejoy
''',
                        "text/plain");
                  },
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
                  onTap: () async {
                    await FirebaseAnalytics()
                        .logEvent(name: "app_review_click");

                    launch(
                        "https://play.google.com/store/apps/details?id=com.app.sharejoy");
                  },
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
      ),
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
