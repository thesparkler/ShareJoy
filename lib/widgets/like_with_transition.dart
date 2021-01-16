import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/like_provider.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class LikeWithTransition extends StatefulWidget {
  final Widget child;
  final Post item;
  final Function onTap;

  const LikeWithTransition({Key key, this.child, this.item, this.onTap})
      : super(key: key);
  @override
  _LikeWithTransitionState createState() => _LikeWithTransitionState();
}

class _LikeWithTransitionState extends State<LikeWithTransition>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  double s = 0;
  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this, value: 0.0);
    // _animation = Tween(0,2000.0,)
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () async {
        print("double tap happend");
        _controller.value = 0.0;
        await _controller.forward();
        await _controller.reverse();
        await _controller.reset();
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
          widget.item.setLike(false);
        } else {
          // await Provider.of<PostProvider>(context, listen: false)
          //     ?.like(widget.item);
          widget.item.setLike(true);
          likes[widget.item.id] = widget.item.toJSON();
          likesArray.add(widget.item.id);
        }
        try {
          final p = await Provider.of<LikeProvider>(context, listen: false)
              ?.notify(widget.item);
        } catch (e) {
          // print(e);
        }
        LocalStorage.instance.put("likes", (likes));
        LocalStorage.instance.put("likes_array", (likesArray));
        setState(() {});
      },
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          widget.child,
          ScaleTransition(
            scale: _animation,
            alignment: Alignment.center,
            child: Opacity(
              opacity:
                  1, // _controller.value > 0.0 ? 1 : 0, //_controller.value,
              child: Container(
                child: Center(
                  child: Icon(
                    widget.item.isLiked
                        ? MdiIcons.heart
                        : MdiIcons.heart,
                    size: 100.0,
                    color: widget.item.isLiked ? Colors.white.withAlpha(250) : Colors.red.withAlpha(250),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
