import 'package:Meme/local_storage.dart';
import 'package:Meme/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          primaryColor: new Color(0xFFD70404), accentColor: Colors.redAccent),
      debugShowCheckedModeBanner: false,
      title: "Meme App",
      home: HomePage(),
    );
  }
}
