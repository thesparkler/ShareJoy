import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class LikeButton extends StatefulWidget {
  final Post item;

  const LikeButton({Key key, this.item}) : super(key: key);
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool processing = false;
  bool isLiked;
  @override
  Widget build(BuildContext context) {
    if (isLiked == null || isLiked != widget.item.isLiked)
      isLiked = widget.item.isLiked;
    return Column(
      children: [
        IconButton(
          tooltip: "Like",
          onPressed: _like,
          icon: processing
              ? Container(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ))
              : isLiked
                  ? Icon(
                      MdiIcons.heart,
                      color: Colors.red,
                    )
                  : Icon(
                      MdiIcons.heartOutline,
                      color: Colors.white,
                    ),
        ),
        // Text(
        //   "Like",
        //   style: TextStyle(color: Colors.white, fontSize: 9.0),
        // )
      ],
    );
  }

  void _like() async {
    setState(() {
      processing = true;
    });
    FirebaseAnalytics().logEvent(name: "content_like", parameters: {
      "id": widget.item.id,
      "type": widget.item.type,
    });

    print("pressed llike buttong");
    var likesArray = await LocalStorage.instance.get("likes_array");
    var likes = await LocalStorage.instance.get("likes");
    if (likesArray == null) {
      likesArray = [];
    }
    if (likes == null) {
      likes = {};
    }
    if (likesArray.contains(widget.item.id)) {
      likesArray.remove(widget.item.id);
      likes.remove(widget.item.id);
      isLiked = false;
    } else {
      await Provider.of<PostProvider>(context, listen: false)
          ?.like(widget.item);
      isLiked = true;
      likes[widget.item.id] = widget.item.toJSON();
      likesArray.add(widget.item.id);
    }

    LocalStorage.instance.put("likes", (likes));
    LocalStorage.instance.put("likes_array", (likesArray));
    widget.item.setLike(isLiked);
    setState(() {
      processing = false;
      isLiked = isLiked;
    });
  }
}
