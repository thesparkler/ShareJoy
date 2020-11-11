import 'package:ShareJoy/firebase_messaging.dart';
import 'package:ShareJoy/screens/home_page.dart';
import 'package:ShareJoy/local_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_update/in_app_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics().logAppOpen();
  await LocalStorage.init();
  PushNotificationHandler.init();
  InAppUpdate.checkForUpdate().then((AppUpdateInfo value) {
    if (value.updateAvailable == true) {
      InAppUpdate.performImmediateUpdate();
    }
  });
  // FacebookAudienceNetwork.init(
  //     // testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
  //     );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          primaryColor: new Color(0xFFD70404), accentColor: Colors.redAccent),
      debugShowCheckedModeBanner: false,
      title: "ShareJoy",
      home: HomePage(),
    );
  }
}
