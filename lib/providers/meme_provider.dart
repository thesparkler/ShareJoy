import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/models/category.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:flutter/widgets.dart';
import 'package:ShareJoy/http_service.dart' show get;

enum ViewState { loading, loaded, showMore, error }

class PostProvider extends ChangeNotifier {
  static var self;
  bool isDisposed = false;
  bool paginationEnabled = true;
  bool isGridView = false;
  // post types = meme | shayari | greetings
  String type;

  // store tab wise categories
  Map<String, List<Category>> categories = {};

  // posts
  List<Post> items = [];
  int pages;
  int currentPage = 1;
  Map<String, dynamic> filters = {};
  var filterLabels = {};

  // view states
  ViewState categoryState = ViewState.loading;
  ViewState memeState = ViewState.loading;

  // always get latest result.
  String lastCategoryUrl;
  String lastPostUrl;

  PostProvider({Map filters}) {
    if (filters != null) {
      type = filters['type'];
      filters.remove("type");

      this.filters = filters;
      fetchPosts();
    }
  }
  static PostProvider instance() {
    if (self == null) {
      self = PostProvider();
    }
    return self;
  }

  void setScrollController(ScrollController scroll) {
    print("setting scroll container");
    scroll.addListener(() {
      // print("scrolling");
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        // print("fetch new page.");
        nextPage();
      }
    });
  }

  // whenever bottom bar tab changes.
  void setType(String newType) {
    if (this.type == newType) {
      return;
    }
    print("setting new type $newType");
    this.type = newType;
    this.filters = {};
    this.currentPage = 1;

    if (categories[type] == null) {
      categoryState = ViewState.loading;
    }

    memeState = ViewState.loading;
    notifyListeners();
    if (categories[type] == null) {
      fetchCategories();
    }

    fetchPosts();
  }

  void fetchCategories() async {
    // load the memes using http request.
    final url = Config.baseUrl + "/categories/$type";
    lastCategoryUrl = url;
    print("fetching categories $type");
    final res = await get(url);

    // if tab is changed old result was scrape.
    if (lastCategoryUrl == res.response.request.url.toString()) {
      categories[type] = [];
      for (var i in res.json()) {
        categories[type].add(Category.fromJSON(i));
      }
      categoryState = ViewState.loaded;
      notify();
    }
  }

  Future<void> fetchPosts() async {
    // load the memes using http request.
    String url = Config.baseUrl + "/posts/$type?page=$currentPage";
    if (filters['category_id'] != null) {
      url += "&category_id=" + filters['category_id'];
    }
    if (filters['category_ids'] != null) {
      url += "&category_ids=" + filters['category_ids'];
    }
    if (filters['lang'] != null) {
      url += "&lang=" + filters['lang'];
    }

    lastPostUrl = url;
    final res = await get(url);
    if (lastPostUrl == res.response.request.url.toString()) {
      final json = res.json();

      if (currentPage == 1) this.items = [];
      Post.showImage = true;
      for (var i in json['data']) {
        this.items.add(Post.fromJSON(i));
      }
      this.currentPage = json['current_page'];
      if (json['total'] == 0) {
        this.pages = 1;
      } else {
        this.pages = json['last_page'];
      }

      this.memeState = ViewState.loaded;
      print("post loaded $type");
      notify();
    }
  }

  void notify() {
    if (isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    print("meme provider $type disposed");
    isDisposed = true;
    super.dispose();
  }

  void filter(String name, String value) {
    currentPage = 1;
    filters[name] = value;
    memeState = ViewState.loading;
    notify();
    fetchPosts();
  }

  Future<void> refresh() async {
    if (memeState == ViewState.loading) return;
    currentPage = 1;
    memeState = ViewState.loading;
    notify();
    await fetchPosts();
    return Future.value();
  }

  void nextPage() {
    if (memeState == ViewState.loading || memeState == ViewState.showMore)
      return;
    print("$pages $currentPage");
    if (pages > currentPage) {
      currentPage += 1;
      memeState = ViewState.showMore;
      notify();
      fetchPosts();
    }
  }

  void toggle() {
    print("toggle");
    this.isGridView = !this.isGridView;
    notify();
  }

  Future<bool> like(Post post) async {
    post.isLiked = true;
    await get(Config.baseUrl + "/posts/like/${post.id}");
    return true;
  }

  Future<bool> view(id) async {
    await get(Config.baseUrl + "/posts/view/$id");
    return true;
  }

  Future<bool> share(id) async {
    await get(Config.baseUrl + "/posts/share/$id");
    return true;
  }

  List<Category> filterCategory(String text) {
    if (text == "" || text == null) {
      return this.categories[this.type];
    }
    List<Category> cats = [];
    for (Category i in this.categories[this.type]) {
      if (i.name.toLowerCase().contains(text.toLowerCase())) {
        cats.add(i);
      }
    }
    return cats;
  }

  addCategoryIntoFilter(String id) {
    var categoryIds = this.filters['category_ids'] ?? "";
    categoryIds = categoryIds.split(",");
    categoryIds.add(id);
    this.filter("category_ids", categoryIds.join(","));
  }

  removeCategoryIntoFilter(String id) {
    var categoryIds = this.filters['category_ids'] ?? "";
    categoryIds = categoryIds.split(",");
    categoryIds.remove(id);
    this.filter("category_ids", categoryIds.join(","));
  }

  List getSelectedCategories() {
    var categoryIds = this.filters['category_ids'] ?? "";
    categoryIds = categoryIds.split(",");
    return categoryIds;
  }

  void changeLanguage(v) {
    switch (v) {
      case 0:
        this.filter("lang", null);
        return;
      case 1:
        this.filter("lang", "english");
        return;
      case 2:
        this.filter("lang", "hindi");
        return;
      case 3:
        this.filter("lang", "marathi");
        return;
    }
  }

  int getSelectedLanguage() {
    switch (this.filters["lang"] ?? null) {
      case "english":
        return 1;
      case "hindi":
        return 2;
      case "marathi":
        return 3;
      default:
        return 0;
    }
  }
}
