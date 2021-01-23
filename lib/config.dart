import 'package:flutter/material.dart';

class Config {
  static String host = "";

  static String baseUrl = host + "api";

  static const types = {
    1: "meme",
    2: "shayari",
    3: "greetings",
  };
  static const titles = {
    "meme": "Memes",
    "shayari": "Shayari",
    "greetings": "Status"
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

  static setHost(String inputHost) {
    host = inputHost;
    print(host);
  }
}
