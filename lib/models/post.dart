import 'dart:convert';

import 'package:ShareJoy/local_storage.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

class Post {
  int id;
  String image;
  String type;
  String caption;
  String renderType;
  Color bg;
  bool isLiked = false;
  String category;
  String toJSON() {
    return json.encode({
      "id": this.id,
      "image": this.image,
      "type": this.type,
      "render_type": this.renderType,
    });
  }

  Post.fromJSON(Map item) {
    this.id = item['id'];
    this.image = item['image'];
    this.type = item['type'];
    this.caption = item['caption'];
    this.renderType = item['render_type'];
    if (item['categories'].length > 0) {
      this.category = item['categories'][0]['name'];
    }

    LocalStorage.instance
        .get("likes_array")
        .then((likesArray) => isLiked = likesArray?.contains(this.id) ?? false);

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
