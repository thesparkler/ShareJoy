import 'dart:ui';

import 'package:ShareJoy/models/category.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/home/category_shimmer.dart';
import 'package:ShareJoy/widgets/radio_group_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryBar extends StatefulWidget {
  const CategoryBar(
      {Key key,
      // @required this.type,
      this.provider})
      : super(key: key);

  final PostProvider provider;

  @override
  _CategoryBarState createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  bool showMore = false;
  TextEditingController _ctrl = new TextEditingController();
  List<Category> categories;
  @override
  void initState() {
    categories = widget.provider.categories[widget.provider.type];

    _ctrl.addListener(() {
      setState(() {
        categories = widget.provider.filterCategory(_ctrl.text);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.provider,
      child: Consumer<PostProvider>(builder: (context, mp, child) {
        print("Category state consumer ${mp.categoryState}");
        if (mp.categoryState == ViewState.loading) return CategoryShimmer();

        return SafeArea(
          child: Container(
            // appBar: AppBar(title: Text("Categories")),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              height: 400.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Content Language",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RadioGroupButton(
                      children: [
                        Text("All"),
                        Text("English"),
                        Text("Hindi"),
                        Text("Marathi"),
                      ],
                      onSelected: (v) {
                        widget.provider.changeLanguage(v);
                      },
                      selected: widget.provider.getSelectedLanguage(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Categories",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Container(
                    height: 30.0,
                    child: TextField(
                      controller: _ctrl,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintText: "Search Categories...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  CustomTheme.h8,
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: 3.1,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CategoryWidget(
                          mp: widget.provider,
                          category: categories[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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
          mp.removeCategoryIntoFilter(category.id.toString());
        } else {
          await FirebaseAnalytics().logEvent(
              name: "category_clicked",
              parameters: {
                "name": category.name,
                "id": category.id,
                "type": category.type
              });
          mp.addCategoryIntoFilter(category.id.toString());
        }
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        margin: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          border: Border.all(
              width: 2.0,
              color:
                  (mp.getSelectedCategories().contains(category.id.toString()))
                      //  ? Theme.of(context).accentColor
                      ? Theme.of(context).accentColor.withAlpha(200)
                      : Colors.transparent // new Color(0xFFC0C0C0),
              ),
          borderRadius: BorderRadius.circular(5.0),
          color: (mp.getSelectedCategories().contains(category.id.toString()))
              ? category.color.withOpacity(1) //Theme.of(context).accentColor
              : category.color,
        ),
        child: Text(
          category.name[0].toUpperCase() + category.name.substring(1),
          //    "#" + category.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 11.0,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
