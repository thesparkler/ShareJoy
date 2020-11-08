import 'package:flutter/material.dart';

class SharejoyHeaderLogo extends StatelessWidget {
  const SharejoyHeaderLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/sharejoy_red.png',
          height: 28,
          width: 28,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "ShareJoy",
            style:
                TextStyle(color: Colors.black, fontFamily: 'FredokaOneRegular'),
          ),
        ),
      ],
    );
  }
}
