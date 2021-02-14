import 'package:ShareJoy/ads_manager.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/screens/single_swiper_view.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/home/list_shimmer.dart';
import 'package:ShareJoy/widgets/like_with_transition.dart';
import 'package:ShareJoy/widgets/nothing_found.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
          return SliverToBoxAdapter(child: ListShimmer());
        }
        if (mp.items.length == 0) {
          return SliverToBoxAdapter(
            child: NothingFound(),
          );
        }
        if (mp.isGridView) {
          return SliverStaggeredGrid.countBuilder(
            crossAxisCount: 4,
            itemCount: mp.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = mp.items[index];

              return PostWidget(
                item: item,
                index: index,
                inGridView: true,
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
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
                  AdsManager.instance.fetchBannerOrNativeAd(index, 6),
                ],
              );
            },
            childCount: mp.items.length + 1,
          ),
        );
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post item;
  final int index;
  final bool inGridView;

  const PostWidget({Key key, this.item, this.index, this.inGridView = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: inGridView ? 0 : 10.0,
          right: inGridView ? 0 : 10.0,
          bottom: inGridView ? 0 : 10.0,
          top: inGridView ? 0 : 5.0),
      child: LikeWithTransition(
        onTap: () => SingleSwiperView.route(
            context, index, Provider.of<PostProvider>(context, listen: false)),
        item: item,
        child: Card(
          // elevation: 5.0,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent, width: 0.5),
              borderRadius: BorderRadius.circular(15)),
          child: item.renderType == "image"
              ? ImagePost(
                  item: item,
                  inGridView: inGridView,
                )
              : TextPost(
                  item: item,
                  inGridView: inGridView,
                ),
        ),
      ),
    );
  }
}

class ImagePost extends StatelessWidget {
  final bool inGridView;
  const ImagePost({
    Key key,
    @required this.item,
    this.inGridView = false,
  }) : super(key: key);

  final Post item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(inGridView ? 0.0 : 10.0),
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
                  height: MediaQuery.of(context).size.height * 0.4,
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
    );
  }
}

class TextPost extends StatelessWidget {
  final Post item;
  final bool inGridView;
  const TextPost({
    Key key,
    this.item,
    this.inGridView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: inGridView
          ? EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0)
          : EdgeInsets.all(30.0),
      height: MediaQuery.of(context).size.height * (inGridView ? 0.3 : 0.5),
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
        style: Theme.of(context).textTheme.headline5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: inGridView ? 16.0 : 30.0,
            ),
      )),
    );
  }
}
