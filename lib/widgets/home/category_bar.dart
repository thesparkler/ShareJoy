import 'package:Meme/models/category.dart';
import 'package:Meme/providers/meme_provider.dart';
import 'package:Meme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({
    Key key,
    @required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, mp, child) {
        print("Category state consumer ${mp.categoryState}");
        if (mp.categoryState == ViewState.loading)
          return CustomTheme.placeHolder;

        final childs = mp.categories[type]
            .map<Widget>((e) => CategoryWidget(
                  category: e,
                  mp: mp,
                ))
            .toList();
        return Wrap(
          spacing: 2.0,
          alignment: WrapAlignment.center,
          children: childs,
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
      onTap: () {
        if (mp.filters['category_id'] == category.id.toString()) {
          mp.filter("category_id", null);
        } else {
          mp.filter("category_id", category.id.toString());
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
          color: (mp.filters['category_id'] == category.id.toString())
              ? Colors.grey
              : Colors.transparent,
        ),
        child: Text(
          "#" + category.name,
          style: TextStyle(
            color: (mp.filters['category_id'] == category.id.toString())
                ? Colors.white
                : Colors.grey,
            fontSize: 11.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
