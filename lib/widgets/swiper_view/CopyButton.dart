import 'package:ShareJoy/models/post.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatelessWidget {
  final Post item;

  const CopyButton({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Copy Text",
      onPressed: () {
        FirebaseAnalytics().logEvent(name: "content_copy", parameters: {
          "id": item.id,
          "type": item.type,
        });

        Clipboard.setData(new ClipboardData(text: item.caption));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Copied."),
        ));
      },
      icon: Icon(
        Icons.content_copy,
        color: Colors.white,
      ),
    );
  }
}
