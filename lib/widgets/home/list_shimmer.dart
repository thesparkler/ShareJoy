import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[400],
      // period: Duratio,
      child: ListView(
        shrinkWrap: true,
        children: [
          Card(
            // elevation: ,
            margin: EdgeInsets.all(12.0),
            child: Container(
              color: Colors.grey[300],
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
          Card(
            // elevation: ,
            margin: EdgeInsets.all(12.0),
            child: Container(
              color: Colors.grey[300],
              height: MediaQuery.of(context).size.height * 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
