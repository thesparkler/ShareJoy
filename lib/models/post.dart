import 'package:flutter/material.dart';
import 'dart:math' as Math;

class Post {
  String image;
  String type;
  String caption;
  String renderType;
  Color bg;
  Post.fromJSON(Map item) {
    this.image = item['image'];
    this.type = item['type'];
    this.caption = item['caption'];
    this.renderType = item['render_type'];
    if (this.renderType == "text") {
      this.bg =
          Colors.primaries[Math.Random().nextInt(Colors.primaries.length - 1)];
    }
  }

  bool canCopyText() {
    return this.renderType == "text" ? true : false;
  }

  bool canChangeBackgroundColor() {
    return this.renderType == "text" ? true : false;
  }
}
