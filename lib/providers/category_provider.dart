import 'package:Meme/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

enum CategoryState {
  initialLoading,
  categoryLoaded,
  listLoading,
  listLoaded,
  error
}

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [];
  CategoryState state = CategoryState.initialLoading;
  CategoryProvider() {
    fetch();
  }
  void fetch() async {
    Query query = FirebaseFirestore.instance.collection('categories');
    query.orderBy("order", descending: false);
    final res = await query.get();
    categories = res.docs.map<Category>((e) => Category.fromDoc(e)).toList();

    if (categories.length == 0) {
      setState(CategoryState.error);
      return;
    }
    print(this.categories);
    setState(CategoryState.categoryLoaded);
    // load the memes.
  }

  void setState(CategoryState state) {
    this.state = state;
    notifyListeners();
  }
}
