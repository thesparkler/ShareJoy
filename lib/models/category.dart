import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  int id;
  String name;
  int codePoint;

  Category.fromDoc(QueryDocumentSnapshot s) {
    name = s.get("name");
    id = s.get("id");
    codePoint = int.parse(s.get("icon"), radix: 16);
  }
}
