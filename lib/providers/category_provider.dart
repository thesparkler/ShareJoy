import 'package:Meme/models/category.dart';
import 'package:flutter/widgets.dart';

enum CategoryState { initialLoading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  CategoryState state = CategoryState.initialLoading;
  CategoryProvider() {
    fetch();
  }
  void fetch() async {
    // load the memes using http request.
  }

  void setState(CategoryState state) {
    this.state = state;
    notifyListeners();
  }
}
