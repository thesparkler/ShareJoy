import 'package:Meme/config.dart';
import 'package:Meme/providers/meme_provider.dart';
import 'package:Meme/widgets/home/category_bar.dart';
import 'package:Meme/widgets/home/post_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemesScreen extends StatelessWidget {
  final String type;
  final scroll = new ScrollController();
  final PostProvider memeProvider = PostProvider.instance();

  MemesScreen({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    memeProvider.setType(this.type);
    memeProvider.setScrollController(scroll);
    print("building meme screen $type");
    return ChangeNotifierProvider.value(
      // lazy: false,
      value: memeProvider,

      child: SingleChildScrollView(
        controller: scroll,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(Config.titles[type],
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontSize: 24.0)),
            ),
            CategoryBar(type: type),
            PostList(type: type)
          ],
        ),
      ),
    );
  }
}
