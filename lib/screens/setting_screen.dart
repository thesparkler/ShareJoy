import 'package:Meme/theme_data.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80.0,
                  child: FlutterLogo(
                    size: 120.0,
                  ),
                ),
                CustomTheme.h8,
                Text("version 1.0.0"),
              ],
            )),
        Expanded(
            child: ListView(
          children: [
            Divider(),
            ListTile(
              onTap: () => Share.text(
                  "Share App",
                  "Download app using following link:https://play.google.com/store/apps/details?id=com.app.sharejoy",
                  "text/plain"),
              title: Text("Share App"),
              subtitle: Text(
                  "Share your love by sharing the application to your friends"),
              trailing: Icon(MdiIcons.shareOutline),
            ),
            Divider(),
            ListTile(
              onTap: () => launch(
                  "https://play.google.com/store/apps/details?id=com.app.sharejoy"),
              title: Text("Rate our App"),
              subtitle: Text("Please let us know your experience."),
              trailing: Icon(MdiIcons.starOutline),
            ),
            Divider(),
          ],
        ))
      ],
    );
  }
}
