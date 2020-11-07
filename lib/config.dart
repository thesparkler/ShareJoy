import 'package:flutter/material.dart';

class Config {
  static const host =
      "http://ec2-13-233-228-241.ap-south-1.compute.amazonaws.com/";

  static const baseUrl = host + "api";

  static const types = {
    1: "meme",
    2: "shayari",
    3: "greetings",
  };
  static const titles = {
    "meme": "Memes",
    "shayari": "Sher-O-Shayari",
    "greetings": "Statuses"
  };

  static const bgColors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.indigo,
    Colors.brown,
    Colors.green,
    Colors.blue,
  ];
}
