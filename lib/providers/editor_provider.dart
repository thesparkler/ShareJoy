import 'package:ShareJoy/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditorProvider extends ChangeNotifier {
  double size = 32;
  Color textColor;
  Color bgColor;
  var prefs;
  String imageUrl;
  bool isDisposed = false;
  // Point x, y;
  EditorProvider(Post item) {
    this.bgColor = item.bg;
    this.textColor = Colors.white;
  }

  void changeTextSize(double size) {
    this.size = size;
    notify();
  }

  void changeBackgroundColor(Color c) {
    print("color changed");
    this.bgColor = c;
    notify();
  }

  void changeTextColor(Color c) {
    print("color changed");
    this.textColor = c;
    notify();
  }

  void changeBackgroundImage(String img) {
    print("image changed");
    this.imageUrl = img;
    notify();
  }

  void setPrefs(var prefs) {
    this.prefs = prefs;
    notify();
  }

  void notify() {
    if (isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
