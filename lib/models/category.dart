class Category {
  int id;
  String name;
  String type;
  Category.fromJSON(Map s) {
    name = s["name"];
    id = s["id"];
    type = s["type"];
  }
}
