import 'dart:io';
import 'dart:typed_data';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui' as ui;

import 'package:provider/provider.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key key,
    @required this.item,
    this.rKey,
  }) : super(key: key);

  final Post item;
  final rKey;
  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Share",
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
    FirebaseAnalytics().logEvent(name: "content_share", parameters: {
      "id": widget.item.id,
      "type": widget.item.type,
    });

    Provider.of<PostProvider>(context, listen: false).share(widget.item.id);
    if (widget.rKey != null) {
      RenderRepaintBoundary boundary =
          widget.rKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      await Share.file('Memes Sharer', 'amlog.jpg', pngBytes, 'image/png');
      // var bs64 = base64Encode(pngBytes);

    } else {
      try {
        var request = await HttpClient().getUrl(Uri.parse(widget.item.image));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        await Share.file('Memes Sharer', 'amlog.jpg', bytes, 'image/jpg');
      } catch (e) {
        print('error: $e');
      }
    }
    setState(() {
      processing = false;
    });
  }
}
