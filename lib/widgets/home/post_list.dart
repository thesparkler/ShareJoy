import 'package:Meme/models/post.dart';
import 'package:Meme/providers/meme_provider.dart';
import 'package:Meme/screens/single_swiper_view.dart';
import 'package:Meme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (mp.items.length == 0) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Text("no $type found"),
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
      child: Card(
        margin: EdgeInsets.all(12.0),
        child: Image.network(
          item.image,
          width: double.infinity,
        ),
      ),
    );
  }
}
