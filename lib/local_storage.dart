import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static LocalStorage instance;
  String _defaultBoxName = "default";

  static init() async {
    await Hive.initFlutter();
    // (await Hive.openBox("default")).clear();
    instance = LocalStorage();
  }

  Future<dynamic> get(key, {String boxName}) async {
    if (boxName == null) boxName = _defaultBoxName;
    Box box = await Hive.openBox(boxName);
    return box.get(key);
  }

  Future<dynamic> put(String key, dynamic value, {String boxName}) async {
    if (boxName == null) boxName = _defaultBoxName;
    Box box = await Hive.openBox(boxName);
    return box.put(key, value);
  }
}
