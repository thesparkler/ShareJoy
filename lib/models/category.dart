class Category {
  int id;
  String name;

  Category.fromJSON(Map s) {
    name = s["name"];
    id = s["id"];
  }
}
