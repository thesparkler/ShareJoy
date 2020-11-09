import 'dart:io';
import 'dart:typed_data';

import 'package:ShareJoy/helpers/watermark_consent_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/rendering.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

import 'package:save_in_gallery/save_in_gallery.dart';

class DownlaodButton extends StatefulWidget {
  const DownlaodButton({
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
  _DownlaodButtonState createState() => _DownlaodButtonState();
}

class _DownlaodButtonState extends State<DownlaodButton> {
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          tooltip: "Download Image",
          onPressed: processing ? null : () => shareImage(context),
          icon: processing
              ? Container(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ))
              : Icon(
                  MdiIcons.downloadOutline,
                  color: widget.color != null ? widget.color : Colors.white,
                ),
        ),
        Text(
          "Save",
          style: TextStyle(color: Colors.white, fontSize: 9.0),
        ),
      ],
    );
  }

  void shareImage(context) async {
    setState(() {
      processing = true;
    });
    FirebaseAnalytics()
        .logEvent(name: "content_${widget.item.type}_save", parameters: {
      "id": widget.item.id,
      "type": widget.item.type,
    });

    var status = await Permission.storage.status;
    if (status.isPermanentlyDenied) {
      return;
    }
    if (status.isUndetermined || status.isDenied) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      try {
        String name = "";
        if (widget.rKey != null) {
          RenderRepaintBoundary boundary =
              widget.rKey.currentContext.findRenderObject();
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          var pngBytes = byteData.buffer.asUint8List();
          pngBytes = await applyWatermark(pngBytes, context, type: "png");
          var name1 = "/image" + DateTime.now().microsecond.toString() + ".png";
          await ImageSaver().saveImage(
            imageBytes: pngBytes,
            imageName: name1,
            directoryName: "ShareJoy",
          );
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("File is saved in your gallery"),
          ));
          setState(() {
            processing = false;
          });

          return;
        } else {
          final res = await http.head(widget.item.image);
          final mimetypes = {
            "image/jpeg": "jpg",
            "image/jpg": "jpg",
            "image/gif": "gif",
            "image/png": "png",
          };
          final ext = mimetypes[res.headers['content-type']] ?? "jpg";
          final wext = mimetypes[res.headers['content-type']] ?? "unknown";
          name = "image" + DateTime.now().microsecond.toString() + "." + ext;
          var request = await HttpClient().getUrl(Uri.parse(widget.item.image));
          var response = await request.close();
          Uint8List bytes = await consolidateHttpClientResponseBytes(response);

          bytes = await applyWatermark(bytes, context, type: wext);

          await ImageSaver().saveImage(
            imageBytes: bytes,
            imageName: name,
            directoryName: "ShareJoy",
          );
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("File is saved in your gallery"),
          ));
        }
      } catch (e) {
        print('error: $e');
      }
    }

    setState(() {
      processing = false;
    });
  }
}
