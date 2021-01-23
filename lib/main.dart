import 'dart:ui';

import 'package:ShareJoy/ads_manager.dart';
import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/firebase_messaging.dart';
import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/screens/home_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAnalytics().logAppOpen();

  await LocalStorage.init();
  PushNotificationHandler.init();
  AdsManager.init();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int ok = 0;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    print("initizaling api details");
    final defaults = <String, dynamic>{'host': ''};
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.setDefaults(defaults);
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    String host = remoteConfig.getString("host");
    if (host == "") {
      setState(() {
        ok = 2;
      });
    } else {
      setState(() {
        Config.setHost(host);
        print("set new host done ${Config.host}");
        ok = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          primaryColor: new Color(0xFFD70404), accentColor: Colors.redAccent),
      debugShowCheckedModeBanner: false,
      title: "ShareJoy",
      home: ok == 1
          ? HomePage()
          : ok == 0
              ? InitialLoader()
              : NoHostFound(onRefresh: initialize),
    );
  }
}

class InitialLoader extends StatefulWidget {
  const InitialLoader({
    Key key,
  }) : super(key: key);

  @override
  _InitialLoaderState createState() => _InitialLoaderState();
}

class _InitialLoaderState extends State<InitialLoader> {
  final theImage = Image.asset(
    "assets/images/loading_data.png",
    width: 550.0,
    height: 300.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(theImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: theImage,
            height: 400.0,
          ),
          Text(
            "Fetching Joy...",
            style: TextStyle(
                fontFamily: 'FredokaOneRegular',
                color: Colors.black,
                fontSize: 24),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class NoHostFound extends StatelessWidget {
  final onRefresh;

  const NoHostFound({Key key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/no_internet_connection.png",
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Text(
              "There is some error while fetching api details.\nplease check your connection and try again.",
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: onRefresh,
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
