import 'package:Meme/models/post.dart';
import 'package:Meme/providers/meme_provider.dart';
import 'package:Meme/screens/single_swiper_view.dart';
import 'package:Meme/theme_data.dart';
import 'package:Meme/widgets/home/list_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                  width: 200.0,
                ),
                Text(
                  "No data found",
                  style: Theme.of(context).textTheme.headline6,
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
            return PostWidget(item: item, index: index);
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
          Card(
            elevation: 12.0,
            margin: EdgeInsets.all(12.0),
            child: item.renderType == "image"
                ? CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: item.image,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[400],
                      child: Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(
                        child: Icon(Icons.warning),
                      ),
                    ),
                  )
                : TextPost(item: item),
          ),
          // Positioned(
          //   bottom: 20.0,
          //   right: 20.0,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(14.0),
          //     ),
          //     child: Text(
          //       item.category ?? '',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 11.0,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // )
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
      color: item.bg,
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
