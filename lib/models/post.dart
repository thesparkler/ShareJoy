import 'dart:convert';

import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/config.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

class Post {
  static var current = 0;
  static bool showImage = true;
  int id;
  String image;
  String type;
  String caption;
  String renderType;
  Color bg;
  String bgImage;
  bool isLiked = false;
  String category;
  String createdAt;
  bool isNew;

  String toJSON() {
    return json.encode({
      "id": this.id,
      "image": this.image,
      "type": this.type,
      "render_type": this.renderType,
      "created_at": this.createdAt,
      "caption": this.caption,
    });
  }

  Post.fromJSON(Map item) {
    this.id = item['id'];
    this.image = item['image'];
    this.type = item['type'];
    this.caption = item['caption'];
    this.renderType = item['render_type'];
    this.createdAt = item['created_at'];
    // if (item['categories'].length > 0) {
    //   this.category = item['categories'][0]['name'];
    // }

    LocalStorage.instance
        .get("likes_array")
        .then((likesArray) => isLiked = likesArray?.contains(this.id) ?? false);

    if (this.renderType == "text") {
      this.bg = Config.bgColors[Post.current];
      if (Post.showImage) {
        int index = Math.Random().nextInt(26) + 1;
        this.bgImage = Config.host + "/images/backgrounds/$index.jpg";
        Post.showImage = false;
      } else {
        Post.showImage = true;
      }
      Post.current = (Post.current + 1) % Config.bgColors.length;
    }
    final d = DateTime.parse(createdAt);
    final diff = DateTime.now().difference(d);
    this.isNew = diff.inDays == 0;
    // print("difference" + diff.inDays.toString());
  }

  bool canCopyText() {
    return this.renderType == "text" ? true : false;
  }

  bool canChangeBackgroundColor() {
    return this.renderType == "text" ? true : false;
  }

  void setLike(bool b) {
    this.isLiked = b;
  }
}
