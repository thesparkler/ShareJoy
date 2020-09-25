import 'package:Meme/config.dart';
import 'package:Meme/models/category.dart';
import 'package:Meme/models/post.dart';
import 'package:flutter/widgets.dart';
import 'package:Meme/http_service.dart' show get;

enum ViewState { loading, loaded, showMore, error }

class PostProvider extends ChangeNotifier {
  static var self;
  bool isDisposed = false;

  // post types = meme | shayari | greetings
  String type;

  // store tab wise categories
  Map<String, List<Category>> categories = {};

  // posts
  List<Post> items = [];
  int pages;
  int currentPage = 1;
  Map<String, dynamic> filters = {};

  // view states
  ViewState categoryState = ViewState.loading;
  ViewState memeState = ViewState.loading;

  // always get latest result.
  String lastCategoryUrl;
  String lastPostUrl;

  static PostProvider instance() {
    if (self == null) {
      self = PostProvider();
    }
    return self;
  }

  void setScrollController(ScrollController scroll) {
    print("setting scroll container");
    scroll.addListener(() {
      print("scrolling");
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

  void fetchPosts() async {
    // load the memes using http request.
    String url = Config.baseUrl + "/posts/$type?page=$currentPage";
    if (filters['category_id'] != null) {
      url += "&category_id=" + filters['category_id'];
    }

    lastPostUrl = url;
    final res = await get(url);
    if (lastPostUrl == res.response.request.url.toString()) {
      final json = res.json();

      if (currentPage == 1) this.items = [];

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

  Future<bool> like(Post post) async {
    post.isLiked = true;
    await get(Config.baseUrl + "/like/${post.id}");
    return true;
  }

  Future<bool> view(id) async {
    await get(Config.baseUrl + "/view/$id");
    return true;
  }

  Future<bool> share(id) async {
    await get(Config.baseUrl + "/share/$id");
    return true;
  }
}
