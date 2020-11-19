import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:ShareJoy/http_service.dart' show get;
import 'package:in_app_update/in_app_update.dart';

class FeedListProvider extends ChangeNotifier {
  bool isDisposed = false;

  List items = [];
  int pages;
  int currentPage = 1;
  Map<String, dynamic> filters = {};

  // view states
  ViewState feedListState = ViewState.loading;

  // always get latest result.
  String lastPostUrl;

  FeedListProvider(ScrollController scroll) {
    this.setScrollController(scroll);
    fetch();
    InAppUpdate.checkForUpdate().then((AppUpdateInfo value) {
      if (value.updateAvailable == true) {
        InAppUpdate.performImmediateUpdate();
      }
    });
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
    fetch();
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow < 12) {
      return 'morning';
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      return 'afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  Future<void> fetch() async {
    // load the memes using http request.
    String slot = this.greetingMessage();
    String url = Config.baseUrl + "/feeds/?page=$currentPage&slot=$slot";

    lastPostUrl = url;
    final res = await get(url);
    if (lastPostUrl == res.response.request.url.toString()) {
      final json = res.json();

      if (currentPage == 1) this.items = [];
      for (var i in json['data']) {
        // TODO:: create model for Feed List.
        this.items.add(i);
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

  void filter(String name, String value) {
    currentPage = 1;
    filters[name] = value;
    feedListState = ViewState.loading;
    notify();
    fetch();
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
