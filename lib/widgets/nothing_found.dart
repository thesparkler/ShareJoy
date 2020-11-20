import 'package:flutter/material.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/nothingfound.png",
            width: 150.0,
          ),
          Text(
            "No data found",
            style: TextStyle(fontFamily: 'RobotoMedium'),
            //      style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
