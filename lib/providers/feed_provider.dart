import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:ShareJoy/http_service.dart' show get;

//@not in use
class FeedProvider extends ChangeNotifier {
  bool isDisposed = false;
  int id;
  List<Post> items = [];
  int pages;
  int currentPage = 1;
  Map<String, dynamic> filters = {};

  // view states
  ViewState feedListState = ViewState.loading;

  // always get latest result.
  String lastPostUrl;

  FeedProvider(int id) {
    this.id = id;
    fetch();
  }

  // whenever bottom bar tab changes.
  void setType(String newType) {
    fetch();
  }

  Future<void> fetch() async {
    // load the memes using http request.
    String url = Config.baseUrl + "/feeds/${this.id}?page=$currentPage";

    lastPostUrl = url;
    final res = await get(url);
    if (lastPostUrl == res.response.request.url.toString()) {
      final json = res.json();

      if (currentPage == 1) this.items = [];
      for (var i in json['data']) {
        // TODO:: create model for Feed.
        this.items.add(Post.fromJSON(i));
      }
      this.currentPage = json['current_page'];
      if (json['total'] == 0) {
        this.pages = 1;
      } else {
        this.pages = json['last_page'];
      }

      this.feedListState = ViewState.loaded;
      notify();
    }
  }

  void notify() {
    if (isDisposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<void> refresh() async {
    if (feedListState == ViewState.loading) return;
    currentPage = 1;
    feedListState = ViewState.loading;
    notify();
    await fetch();
    return Future.value();
  }

  void nextPage() {
    if (feedListState == ViewState.loading ||
        feedListState == ViewState.showMore) return;
    print("$pages $currentPage");
    if (pages > currentPage) {
      currentPage += 1;
      feedListState = ViewState.showMore;
      notify();
      fetch();
    }
  }
}
