import 'dart:ui';

import 'package:ShareJoy/models/category.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/widgets/home/category_shimmer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as Math;

class CategoryBar extends StatefulWidget {
  const CategoryBar({
    Key key,
    @required this.type,
  }) : super(key: key);

  final String type;

  @override
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, mp, child) {
        print("Category state consumer ${mp.categoryState}");
        if (mp.categoryState == ViewState.loading) return CategoryShimmer();
        // return CustomTpheme.placeHolder;

        final childs = mp.categories[widget.type]
            .map<Widget>((e) => CategoryWidget(
                  category: e,
                  mp: mp,
                ))
            .toList();

        final child = mp.categories[widget.type]
            .map<Widget>((e) => CategoryWidget(
                  category: e,
                  mp: mp,
                ))
            .toList();

        //var shorts = childs.sublist(0, Math.min(8, childs.length));

        var shortChilds = childs.sublist(
            0, Math.min(showMore ? childs.length : 8, childs.length));
        if (childs.length > 8) {
          shortChilds.add(InkWell(
            onTap: () {
              setState(() {
                showMore = !showMore;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              margin: const EdgeInsets.only(
                top: 5.0
              ),
              decoration: BoxDecoration(
                  //    border: Border.all(color: Colors.grey),
                  //  borderRadius: BorderRadius.circular(20.0),
                  //  color: Colors.white,
                  ),
              child: showMore
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("less",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )))
                  : Text(
                      "more",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
            ),
          ));
        }
        return Wrap(
          spacing: 2.0,
          alignment: WrapAlignment.start,
          children: shortChilds,
        );
      },
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final mp;
  final Category category;
  const CategoryWidget({Key key, this.mp, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (mp.filters['category_id'] == category.id.toString()) {
          mp.filter("category_id", null);
        } else {
          await FirebaseAnalytics().logEvent(
              name: "category_clicked",
              parameters: {
                "name": category.name,
                "id": category.id,
                "type": category.type
              });

          mp.filter("category_id", category.id.toString());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: (mp.filters['category_id'] == category.id.toString())
          //     //  ? Theme.of(context).accentColor
          //       ? Theme.of(context).accentColor
          //       : new Color(0xFFC0C0C0),
          // ),
          borderRadius: BorderRadius.circular(20.0),
          color: (mp.filters['category_id'] == category.id.toString())
             // ? Theme.of(context).primaryColor
              ? Theme.of(context).accentColor
              : new Color(0xFFdcdcdc),
        ),
        child: Text(
          category.name,
      //    "#" + category.name,
          style: TextStyle(
            color: (mp.filters['category_id'] == category.id.toString())
                ? Colors.white
                : Colors.black,
            fontSize: 11.0,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
