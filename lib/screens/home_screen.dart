import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/feed_list_provider.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/screens/single_swiper_view.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/sharejoy_header_logo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_audience_network_ad/ad/ad_banner.dart';
import 'package:fb_audience_network_ad/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ShareJoy/http_service.dart' show reportImageError;

class HomeScreen extends StatelessWidget {
  final scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedListProvider(scroll),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: CustomScrollView(controller: scroll, slivers: <Widget>[
          SliverAppBar(
            shadowColor: Colors.black,
            forceElevated: true,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20.0),
            )),
            title: const SharejoyHeaderLogo(),
            actions: [
              // DropdownButton(items: null, onChanged: null)
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8.0),
              Consumer<FeedListProvider>(
                builder: (context, flp, snapshot) {
                  return FeedList(flp: flp);
                },
              ),
            ]),
          )
        ]),
      ),
    );
  }
}

class FeedList extends StatelessWidget {
  final FeedListProvider flp;

  const FeedList({Key key, this.flp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: flp.items.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Feed(item: flp.items[(index)], feedIndex: index),
      //      index % 4 == 0
            //     ?
            // index % 8 ==0?
            //
            // FacebookNativeAd(
            //         placementId: "1265998170441655_1294758274232311",
            //         adType: NativeAdType.NATIVE_AD_TEMPLATE,
            //         listener: (result, value) {
            //           print("Banner Ad $result --> $value");
            //         },
            //       ):FacebookBannerAd(
            //   placementId: "1265998170441655_1266012507106888",
            //   bannerSize: BannerSize.MEDIUM_RECTANGLE,
            //   listener: (result, value) {
            //     print("Banner Ad $result --> $value");
            //   },
            // )
            //     : CustomTheme.placeHolder
          ],
        );
      },
    );
  }
}

class Feed extends StatelessWidget {
  final item, feedIndex;

  const Feed({Key key, this.item, this.feedIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(filters: item['condition']),
      child: Consumer<PostProvider>(builder: (context, fp, child) {
        return fp.items.length == 0
            ? CustomTheme.placeHolder
            : Container(
                height: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'RobotoMedium'
                            ),
                          ),
                          // Text("more"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        itemCount: fp.items.length,
                        itemBuilder: (context, index) {
                          final feedItem = fp.items[index];
                          return PostWidget(
                            item: feedItem,
                            index: index,
                            feedIndex: feedIndex
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key key,
    @required this.item,
    this.index,
    this.feedIndex
  }) : super(key: key);

  final Post item;
  final int index;
  final int feedIndex;

  @override
  Widget build(BuildContext context) {
    double percentage = (feedIndex==0)?0.8:0.4;
    return GestureDetector(
      onTap: () => SingleSwiperView.route(
          context, index, Provider.of<PostProvider>(context, listen: false)),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * percentage,
            margin: EdgeInsets.only(
                left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0.5),
                  borderRadius: BorderRadius.circular(15)),
              child: item.renderType == "image"
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      // padding: EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                          width: double.infinity,
                          imageUrl: item.image,
                          placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300],
                                highlightColor: Colors.grey[400],
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  color: Colors.grey,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                              ),
                          errorWidget: (context, url, error) {
                            reportImageError(item.id);
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Center(
                                child: Icon(Icons.image),
                              ),
                            );
                          }),
                    )
                  : TextPost(item: item),
            ),
          ),
          CustomTheme.placeHolder,
        ],
      ),
    );
  }
}

class TextPost extends StatelessWidget {
  final Post item;

  const TextPost({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height * 0.5,
      //  color: item.bg,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10.0),
      //     color: item.bg

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        color: item.bg,
        image: item.bgImage != null
            ? DecorationImage(

                fit: BoxFit.cover,
                image: NetworkImage(item.bgImage),
              )
            : null,
      ),

      child: Center(
        child: Text(
          item.caption,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}