import 'package:Meme/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider(),
      child: Scaffold(
        bottomNavigationBar: Consumer<CategoryProvider>(
            builder: (ctx, CategoryProvider hp, child) {
          print(hp.categories);
          if (hp.state == CategoryState.initialLoading)
            return SizedBox(
              height: 0,
            );
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (v) {
              int cat = hp.categories[v].id;
              print("category selected $cat");
            },
            items: hp.categories
                .map((e) => BottomNavigationBarItem(
                      icon: Icon(
                          IconData(e.codePoint, fontFamily: 'MaterialIcons')),
                      title: Text(e.name),
                    ))
                .toList(),
          );
        }),
        body: Consumer<CategoryProvider>(
            builder: (ctx, CategoryProvider hp, child) {
          if (hp.state == CategoryState.initialLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(child: Text("Hello world"));
        }),
      ),
    );
  }
}
