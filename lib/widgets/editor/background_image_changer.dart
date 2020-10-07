import 'package:ShareJoy/config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BackgroundImageChanger extends StatelessWidget {
  final onChanged;
  final selectedValue;
  const BackgroundImageChanger({
    Key key,
    this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2, crossAxisSpacing: 3.0),
        itemCount: 28,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () => onChanged(null),
              child: Container(
                margin: EdgeInsets.all(4.0),
                color: Colors.grey,
                width: 100.0,
                height: 100.0,
                child: Center(
                    child: Text(
                  "No Image",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            );
          }
          return GestureDetector(
            onTap: () =>
                onChanged(Config.host + "/images/backgrounds/$index.jpg"),
            child: Container(
              width: 100.0,
              height: 100.0,
              margin: EdgeInsets.all(4.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 50.0,
                  height: 50.0,
                  color: Colors.grey,
                ),
                imageUrl: Config.host + "/images/backgrounds/$index.jpg",
              ),
            ),
          );
        },
      ),
    );
  }
}
