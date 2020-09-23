import 'package:Meme/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const bool USE_FIRESTORE_EMULATOR = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      title: "Meme App",
      home: HomePage(),
    );
  }
}
