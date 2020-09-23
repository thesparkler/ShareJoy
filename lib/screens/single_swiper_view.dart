import 'package:Meme/models/post.dart';
import 'package:Meme/providers/meme_provider.dart';
import 'package:Meme/widgets/swiper_view/share_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
          return PageView.builder(
              controller: _ctrl,
              scrollDirection: Axis.vertical,
              itemCount: mp.items.length,
              itemBuilder: (context, index) {
                Post item = mp.items[index];
                return Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: Image.network(item.image),
                      ),
                    ),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Positioned(
                        left: 5,
                        bottom: 10,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            MdiIcons.heartOutline,
                            color: Colors.white,
                          ),
                        )),
                    Positioned(
                      right: 5,
                      bottom: 10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              MdiIcons.downloadOutline,
                              color: Colors.white,
                            ),
                          ),
                          ShareButton(item: item),
                        ],
                      ),
                    )
                  ],
                );
              });
        }),
      ),
    );
  }
}
