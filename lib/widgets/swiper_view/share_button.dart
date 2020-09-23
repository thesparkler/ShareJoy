import 'dart:io';
import 'dart:typed_data';

import 'package:Meme/models/post.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Post item;

  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: processing ? null : shareImage,
      icon: processing
          ? Container(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ))
          : Icon(
              MdiIcons.shareOutline,
              color: Colors.white,
            ),
    );
  }

  void shareImage() async {
    setState(() {
      processing = true;
    });
    try {
      var request = await HttpClient().getUrl(Uri.parse(widget.item.image));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('Memes Sharer', 'amlog.jpg', bytes, 'image/jpg');
    } catch (e) {
      print('error: $e');
    }
    setState(() {
      processing = false;
    });
  }
}
