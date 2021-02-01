import 'dart:ui';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/widgets/filter_bar.dart';
import 'package:ShareJoy/widgets/home/category_bar.dart';
import 'package:ShareJoy/widgets/home/post_list.dart';
import 'package:ShareJoy/widgets/sharejoy_header_logo.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class MemesScreen extends StatelessWidget {
  final String type;
  final scroll = new ScrollController();
  final Map filter;
  final PostProvider memeProvider = PostProvider.instance();

  MemesScreen({Key key, this.type, this.filter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    memeProvider.applyMapFilter(filter);
    memeProvider.setType(this.type);

    memeProvider.setScrollController(scroll);
    print("building meme screen $type");
    return ChangeNotifierProvider.value(
      // lazy: false,
      value: memeProvider,

      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: RefreshIndicator(
          onRefresh: () => memeProvider.refresh(),
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
                Consumer<PostProvider>(builder: (context, pp, child) {
                  return IconButton(
                    color: Colors.black,
                    icon: pp.isGridView
                        ? Icon(Icons.list_alt)
                        : Icon(Icons.grid_view),
                    onPressed: () {
                      pp.toggle();
                    },
                  );
                }),
                IconButton(
                  color: Colors.black,
                  icon: Icon(MdiIcons.filterVariant),
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CategoryBar(provider: memeProvider),
                    );
                  },
                ),
              ],
            ),
            const SliverToBoxAdapter(child: const SizedBox(height: 8.0)),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 12.0),
                child: FilterBar(),
              ),
            ),
            PostList(type: type),
          ]),
        ),
      ),
    );
  }
}
