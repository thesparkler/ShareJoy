import 'package:ShareJoy/models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShareJoy/providers/meme_provider.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, pp, child) {
        List<Widget> childs = [];
        if (pp.filters['lang'] != null && pp.filters['lang'] != '') {
          childs.add(
            CustomChip(
                label: pp.filters['lang'],
                onDeleted: () => pp.filter("lang", null)),
          );
        }
        if (pp.categories[pp.type] != null) {
          for (Category category in pp.categories[pp.type]) {
            List selected = pp.getSelectedCategories();
            if (selected.contains(category.id.toString())) {
              childs.add(CustomChip(
                label: category.name,
                onDeleted: () {
                  pp.removeCategoryIntoFilter(category.id.toString());
                },
              ));
            }
          }
        }

        return Wrap(
          spacing: 4.0,
          children: childs,
        );
      },
    );
  }
}

class CustomChip extends StatelessWidget {
  final String label;
  final Function onDeleted;

  const CustomChip({Key key, this.label, this.onDeleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(fontSize: 11.0),
      ),
      deleteIcon: Icon(Icons.clear),
      deleteIconColor: Colors.black54,
      onDeleted: onDeleted,
    );
  }
}
