import 'package:Meme/config.dart';
import 'package:flutter/material.dart';

class MemesScreen extends StatelessWidget {
  final String type;

  const MemesScreen({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(Config.titles[type],
            style:
                Theme.of(context).textTheme.headline6.copyWith(fontSize: 24.0)),
      ),
      CategoryView(type),
      MemesList(type),
    ]);
  }
}
