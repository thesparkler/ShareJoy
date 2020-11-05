import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/feed_list_provider.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/screens/single_swiper_view.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedListProvider(scroll),
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
          title: Row(
            children: [
              Image.asset(
                'assets/images/sharejoy_red.png',
                height: 28,
                width: 28,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "ShareJoy",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'FredokaOneRegular'),
                ),
              ),
            ],
          ),
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
            Container(
              height: 250.0,
              child: Feed(item: flp.items[index]),
            ),
          ],
        );
      },
    );
  }
}

class Feed extends StatelessWidget {
  final item;

  const Feed({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostProvider(filters: item['condition']),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Text("more"),
              ],
            ),
          ),
          Expanded(
            child: Consumer<PostProvider>(
              builder: (context, fp, snapshot) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  itemCount: fp.items.length,
                  itemBuilder: (context, index) {
                    final feedItem = fp.items[index];
                    return PostWidget(
                      item: feedItem,
                      index: index,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
            width: MediaQuery.of(context).size.width * 0.4,
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent, width: 0.5),
                  borderRadius: BorderRadius.circular(15)),
              child: item.renderType == "image"
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      // padding: EdgeInsets.all(10.0),
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
                        errorWidget: (context, url, error) => Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Icon(Icons.warning),
                          ),
                        ),
                      ),
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
          child: Text(item.caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ))),
    );
  }
}
