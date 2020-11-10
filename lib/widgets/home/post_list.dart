import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/screens/single_swiper_view.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/home/list_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fb_audience_network_ad/ad/ad_banner.dart';
import 'package:fb_audience_network_ad/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ShareJoy/http_service.dart' show reportImageError;

class PostList extends StatelessWidget {
  const PostList({
    Key key,
    @required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, mp, child) {
        print("meme state consumer ${mp.memeState}");

        if (mp.memeState == ViewState.loading) {
          return ListShimmer();
        }
        if (mp.items.length == 0) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/nothingfound.png",
                  width: 150.0,
                ),
                Text(
                  "No data found",
                  style: TextStyle(fontFamily: 'RobotoMedium'),
                  //      style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        }
        // return Container(child: Text("$type loaded"));
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: mp.items.length + 1,
          itemBuilder: (context, index) {
            if (mp.items.length == index) {
              if (mp.memeState == ViewState.showMore) {
                return Container(
                    height: 30.0,
                    child: Center(child: CircularProgressIndicator()));
              }
              return CustomTheme.placeHolder;
            }
            final item = mp.items[index];
            return Column(
              children: [
                PostWidget(item: item, index: index),
                index % 4 == 0
                    ? index % 8 == 0 && index != 0
                        ? FacebookNativeAd(
                            placementId: "1265998170441655_1294758274232311",
                            adType: NativeAdType.NATIVE_AD_TEMPLATE,
                            listener: (result, value) {
                              print("Banner Ad $result --> $value");
                            },
                          )
                        : FacebookBannerAd(
                            placementId: "1265998170441655_1266012507106888",
                            bannerSize: BannerSize.STANDARD,
                            listener: (result, value) {
                              print("Banner Ad $result --> $value");
                            },
                          )
                    : CustomTheme.placeHolder,
              ],
            );
          },
        );
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key key,
    @required this.item,
    this.index,
  }) : super(key: key);

  final Post item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SingleSwiperView.route(
          context, index, Provider.of<PostProvider>(context, listen: false)),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0.5),
                  borderRadius: BorderRadius.circular(15)),
              child: item.renderType == "image"
                  ? Container(
                      padding: EdgeInsets.all(10.0),
                      child: CachedNetworkImage(
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
                                child: Icon(Icons.warning),
                              ),
                            );
                          }),
                    )
                  : TextPost(item: item),
            ),
          ),

          //  ),

          // item.isNew
          //     ? Positioned(
          //         top: -0.0,
          //         right: -0.0,
          //         child: Container(
          //           margin: EdgeInsets.all(0.0),
          //           padding:
          //               EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
          //           decoration: BoxDecoration(
          //             color: Theme.of(context).primaryColor,
          //             shape: BoxShape.circle,
          //             // borderRadius: BorderRadius.circular(132.0),
          //           ),
          //           child: Text(
          //             'New',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 11.0,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       )
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
      padding: EdgeInsets.all(30.0),
      height: MediaQuery.of(context).size.height * 0.5,
      //  color: item.bg,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10.0),
      //     color: item.bg

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
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
        style: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      )),
    );
  }
}
