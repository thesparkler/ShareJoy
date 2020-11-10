import 'package:ShareJoy/http_service.dart' show reportImageError;
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/screens/editor.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/sharejoy_watermark.dart';
import 'package:ShareJoy/widgets/swiper_view/CopyButton.dart';
import 'package:ShareJoy/widgets/swiper_view/download_button.dart';
import 'package:ShareJoy/widgets/swiper_view/like_button.dart';
import 'package:ShareJoy/widgets/swiper_view/share_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_audience_network_ad/ad/ad_banner.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SingleSwiperView extends StatefulWidget {
  final PostProvider mp;
  final int index;
  const SingleSwiperView({Key key, this.mp, this.index}) : super(key: key);

  static route(context, int idx, PostProvider mp) {
    FirebaseAnalytics().logEvent(name: "detail_view_open", parameters: {});

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SingleSwiperView(
          index: idx,
          mp: mp,
        ),
      ),
    );
  }

  @override
  _SingleSwiperViewState createState() => _SingleSwiperViewState();
}

class _SingleSwiperViewState extends State<SingleSwiperView> {
  PageController _ctrl;

  @override
  void initState() {
    _ctrl = PageController(initialPage: this.widget.index);
    _ctrl.addListener(() {
      int page = _ctrl.page.round();
      int total = widget.mp.items.length;
      if ((total - page) == 2) {
        widget.mp.nextPage();
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
                    return item.renderType == "image"
                        ? SinglePostWidget(item: item)
                        : SingleTextPostWidget(item: item);
                  }),
              Positioned(
                child: SafeArea(
                  child: BackButton(
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 50.0,
                right: 0,
                child: SafeArea(
                  child: FacebookBannerAd(
                    placementId: "1265998170441655_1266012507106888",
                    bannerSize: BannerSize.STANDARD,
                    listener: (result, value) {
                      print("Banner Ad $result --> $value");
                    },
                  ),
                ),
              ),
            ],
          );
        }),
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
        Container(
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
                child: Icon(Icons.image, size: 50,),
              ),
            ),
          )),

        ),
        Positioned(
          left: 5,
          bottom: 10,
          child: LikeButton(item: item),
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
        RepaintBoundary(
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
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
                          ),
                        ),
                      )
                    : CustomTheme.placeHolder,
              ],
            ),
          ),
        ),
        Positioned(
          left: 5,
          bottom: 10,
          child: LikeButton(item: widget.item),
        ),
        Positioned(
          right: 5,
          bottom: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.item.canChangeBackgroundColor()
                  ? Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            FirebaseAnalytics().logEvent(
                                name: "content_${widget.item.type}_edit",
                                parameters: {
                                  "id": widget.item.id,
                                  "type": widget.item.type,
                                });

                            Editor.route(context, widget.item);
                          },
                          icon: Icon(
                            MdiIcons.palette,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(color: Colors.white, fontSize: 9.0),
                        )
                      ],
                    )
                  : CustomTheme.placeHolder,
              widget.item.canCopyText()
                  ? CopyButton(item: widget.item)
                  : CustomTheme.placeHolder,
              DownlaodButton(
                item: widget.item,
                rKey: _key,
                watermarkCallback: (newPrefs) {
                  setState(() {
                    this.prefs = newPrefs;
                  });
                  print("watermark callback called");
                },
              ),
              ShareButton(
                item: widget.item,
                rKey: _key,
                watermarkCallback: (newPrefs) {
                  setState(() {
                    this.prefs = newPrefs;
                  });
                  print("watermark callback called");
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
