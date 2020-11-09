import 'dart:io';
import 'dart:typed_data';
import 'package:ShareJoy/helpers/watermark_consent_helper.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui' as ui;

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key key,
    @required this.item,
    this.rKey,
    this.color,
    this.watermarkCallback,
  }) : super(key: key);

  final Post item;
  final rKey;
  final color;
  final watermarkCallback;
  @override
  _ShareButtonState createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
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
                  color: widget.color != null ? widget.color : Colors.white,
                ),
        ),
        Text(
          "Share",
          style: TextStyle(color: Colors.white, fontSize: 9.0),
        ),
      ],
    );
  }

  void shareImage() async {
    setState(() {
      processing = true;
    });
    FirebaseAnalytics()
        .logEvent(name: "content_${widget.item.type}_share", parameters: {
      "id": widget.item.id,
      "type": widget.item.type,
    });

    // Provider.of<PostProvider>(context, listen: false).share(widget.item.id);
    if (widget.rKey != null) {
      RenderRepaintBoundary boundary =
          widget.rKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var sharedImageInts =
          await applyWatermark(pngBytes, context, type: "png");
      // encodePng(image)
      await Share.file('ShareJoy', 'amlog.png', sharedImageInts, 'image/png');
    } else {
      try {
        var request = await HttpClient().getUrl(Uri.parse(widget.item.image));
        var response = await request.close();
        final mimetypes = {
          "image/jpeg": "jpg",
          "image/jpg": "jpg",
          "image/gif": "gif",
          "image/png": "png",
        };

        final ext = mimetypes[response.headers.contentType.value] ?? "unknown";

        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        var sharedImageInts = await applyWatermark(bytes, context, type: ext);
        await Share.file('ShareJoy', 'amlog.png', sharedImageInts, 'image/png');
      } catch (e) {
        print('error: $e');
      }
    }
    setState(() {
      processing = false;
    });
  }
}
