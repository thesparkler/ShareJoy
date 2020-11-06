import 'dart:math';

import 'package:ShareJoy/config.dart';
import 'package:flutter/material.dart';

class Category {
  int id;
  String name;
  String type;
  Color color;
  Category.fromJSON(Map s) {
    name = s["name"];
    id = s["id"];
    type = s["type"];
    color = Config.bgColors[Random().nextInt(Config.bgColors.length)][100];
  }
}
