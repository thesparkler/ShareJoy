class Post {
  String image;
  String type;

  Post.fromJSON(Map item) {
    this.image = item['image'];
    this.type = item['type'];
  }
}
