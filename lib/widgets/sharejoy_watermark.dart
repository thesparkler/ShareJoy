import 'package:ShareJoy/theme_data.dart';
import 'package:flutter/material.dart';

class SharejoyWatermark extends StatelessWidget {
  const SharejoyWatermark({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Shared from",
            style: TextStyle(
              fontSize: 9.0,
              color: Colors.white,
            ),
          ),
          CustomTheme.h2,
          Row(
            children: [
              Image.asset("assets/images/icon.png", width: 16.0, height: 16.0),
              Text(
                " ShareJoy",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
