import 'package:ShareJoy/models/post.dart';
import 'package:flutter/cupertino.dart';

class LikeProvider extends ChangeNotifier {
  bool isDisposed = false;
  Post item;

  LikeProvider(this.item);

  notify(Post item) {
    this.item = item;
    if (!isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
