import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FeedShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[400],
      // period: Duratio,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              top: 4.0,
              right: MediaQuery.of(context).size.width * 0.5,
            ),
            width: 30.0,
            height: 20.0,
            color: Colors.grey,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.grey,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              left: 16.0,
              top: 4.0,
              right: MediaQuery.of(context).size.width * 0.5,
            ),
            width: 50.0,
            height: 20.0,
            color: Colors.grey,
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.grey,
              ),
              Container(
                margin: EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
