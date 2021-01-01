import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/screens/editor.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Post item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            FirebaseAnalytics()
                .logEvent(name: "content_${item.type}_edit", parameters: {
              "id": item.id,
              "type": item.type,
            });

            Editor.route(context, item);
          },
          icon: Icon(
            MdiIcons.palette,
            color: Colors.white,
          ),
        ),
        Text(
          "Edit",
          style: TextStyle(color: Colors.white, fontSize: 9.0),
        )
      ],
    );
  }
}
