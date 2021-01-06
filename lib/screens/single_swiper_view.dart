import 'package:ShareJoy/ads_manager.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/like_provider.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/like_with_transition.dart';
import 'package:ShareJoy/widgets/sharejoy_watermark.dart';
import 'package:ShareJoy/widgets/swiper_view/CopyButton.dart';
import 'package:ShareJoy/widgets/swiper_view/download_button.dart';
import 'package:ShareJoy/widgets/swiper_view/edit_button.dart';
import 'package:ShareJoy/widgets/swiper_view/like_button.dart';
import 'package:ShareJoy/widgets/swiper_view/share_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SingleSwiperView extends StatefulWidget {
  final PostProvider mp;
  final int index;
  const SingleSwiperView({Key key, this.mp, this.index}) : super(key: key);

  static route(context, int idx, PostProvider mp) async {
    FirebaseAnalytics().logEvent(name: "detail_view_open", parameters: {});
    final ssv = SingleSwiperView(
      index: idx,
      mp: mp,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ssv,
      ),
    );
  }

  @override
  _SingleSwiperViewState createState() => _SingleSwiperViewState();
}

class _SingleSwiperViewState extends State<SingleSwiperView> {
  int lastPage = 0;
  PageController _ctrl;
  @override
  void initState() {
    _ctrl = PageController(initialPage: this.widget.index);
    _ctrl.addListener(() {
      int page = _ctrl.page.round();
      if (lastPage != page) {
        lastPage = page;
      }
      int total = widget.mp.items.length;
      if ((total - page) == 2) {
        widget.mp.nextPage();
      }
      if (lastPage % 2 == 1) {
        print("calling interestial ad $lastPage");
        AdsManager.instance.fetchInterestialAd();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.mp,
      child: Scaffold(
        body: Consumer<PostProvider>(builder: (context, mp, child) {
          return Stack(
            children: [
              PageView.builder(
                  controller: _ctrl,
                  scrollDirection: Axis.horizontal,
                  itemCount: mp.items.length,
                  itemBuilder: (context, index) {
                    Post item = mp.items[index];
                    return DetailView(item: item);
                  }),
              Positioned(
                child: SafeArea(
                  child: BackButton(
                    color: Colors.white,
                  ),
                ),
              ),
              // Positioned(
              //   left: 50.0,
              //   right: 0,
              //   child: SafeArea(
              //     child: FacebookBannerAd(
              //       placementId: "1265998170441655_1266012507106888",
              //       bannerSize: BannerSize.STANDARD,
              //       listener: (result, value) {
              //         print("Banner Ad $result --> $value");
              //       },
              //     ),
              //   ),
              // ),
            ],
          );
        }),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Post item;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LikeProvider(item),
      child: LikeWithTransition(
        item: item,
        child: item.renderType == "image"
            ? SinglePostWidget(item: item)
            : SingleTextPostWidget(item: item),
      ),
    );
  }
}

class SinglePostWidget extends StatelessWidget {
  const SinglePostWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Post item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          child: Container(
            color: Colors.black,
            child: Center(
                child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: item.image,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[400],
                child: Container(
                  color: Colors.grey,
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                  ),
                ),
              ),
            )),
          ),
        ),
        Positioned(
          left: 5,
          bottom: 10,
          child: Consumer<LikeProvider>(
            builder: (_, lp, ___) {
              print("like changed ${lp.item.isLiked}");
              return LikeButton(item: lp.item);
            },
          ),
        ),
        Positioned(
          right: 5,
          bottom: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DownlaodButton(item: item),
              ShareButton(item: item),
            ],
          ),
        )
      ],
    );
  }
}

class SingleTextPostWidget extends StatefulWidget {
  SingleTextPostWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Post item;

  @override
  _SingleTextPostWidgetState createState() => _SingleTextPostWidgetState();
}

class _SingleTextPostWidgetState extends State<SingleTextPostWidget> {
  final GlobalKey _key = new GlobalKey();
  var bg;
  var bgImage;
  var prefs;
  @override
  Widget build(BuildContext context) {
    if (bg == null) bg = widget.item.bg;
    if (bgImage == null)
      bgImage = widget.item.bgImage != null
          ? DecorationImage(
              image: NetworkImage(widget.item.bgImage),
              fit: BoxFit.cover,
            )
          : null;
    return Stack(
      children: [
        InteractiveViewer(
          child: RepaintBoundary(
            key: _key,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      color: bg,
                      image: bgImage,
                    ),
                    child: Center(
                      child: Text(
                        widget.item.caption,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  prefs != null && prefs['sharejoyWatermark'] == true
                      ? Positioned(
                          right: 10.0,
                          bottom: 50.0,
                          child: SharejoyWatermark(),
                        )
                      : CustomTheme.placeHolder,
                  prefs != null && prefs['userWatermark'] != ""
                      ? Positioned(
                          left: 10.0,
                          bottom: 50.0,
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              prefs['userWatermark'],
                              style: TextStyle(
                                  fontSize: 22.0, color: Colors.white),
                            ),
                          ),
                        )
                      : CustomTheme.placeHolder,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 5,
          bottom: 10,
          child: Consumer<LikeProvider>(builder: (_, __, ___) {
            print("like changed");
            widget.item.isLiked = !widget.item.isLiked;
            return LikeButton(item: widget.item);
          }),
        ),
        Positioned(
          right: 5,
          bottom: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.item.canChangeBackgroundColor()
                  ? EditButton(item: widget.item)
                  : CustomTheme.placeHolder,
              widget.item.canCopyText()
                  ? CopyButton(item: widget.item)
                  : CustomTheme.placeHolder,
              DownlaodButton(
                item: widget.item,
                rKey: _key,
              ),
              ShareButton(
                item: widget.item,
                rKey: _key,
              ),
            ],
          ),
        )
      ],
    );
  }
}
