import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/screens/editor.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/swiper_view/CopyButton.dart';
import 'package:ShareJoy/widgets/swiper_view/bg_change_button.dart';
import 'package:ShareJoy/widgets/swiper_view/download_button.dart';
import 'package:ShareJoy/widgets/swiper_view/like_button.dart';
import 'package:ShareJoy/widgets/swiper_view/share_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
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
                  scrollDirection: Axis.vertical,
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
                child: Icon(Icons.warning),
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
  @override
  Widget build(BuildContext context) {
    if (bg == null) bg = widget.item.bg;
    return Stack(
      children: [
        RepaintBoundary(
          key: _key,
          child: Container(
            color: Colors.white,
            child: Container(
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
                  ? IconButton(
                      onPressed: () {
                        Editor.route(context, widget.item);
                      },
                      icon: Icon(
                        MdiIcons.palette,
                        color: Colors.white,
                      ))
                  : CustomTheme.placeHolder,
              // widget.item.canChangeBackgroundColor()
              //     ? BGChangeButton(
              //         item: widget.item,
              //         onChange: (v, img) {
              //           print(v);
              //           setState(() {
              //             bg = v;
              //             bgImage = img;
              //           });
              //         })
              //     : CustomTheme.placeHolder,
              widget.item.canCopyText()
                  ? CopyButton(item: widget.item)
                  : CustomTheme.placeHolder,
              DownlaodButton(item: widget.item, rKey: _key),
              ShareButton(item: widget.item, rKey: _key),
            ],
          ),
        )
      ],
    );
  }
}
