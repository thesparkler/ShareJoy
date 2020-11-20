import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/widgets/watermark_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart';

Future<Map> getUserWatermarkPreferences(BuildContext context) async {
  var prefs = await LocalStorage.instance.get("watermark_prefs");
  if (prefs == null) {
    await showDialog(
      context: context,
      child: WatermarkAlert(
          onSubmit: (String userWatermark, bool sharejoyWatermark) {
        prefs = {
          "userWatermark": userWatermark,
          "sharejoyWatermark": sharejoyWatermark
        };
        LocalStorage.instance.put("watermark_prefs", prefs);
      }),
    );
  }
  return prefs;
}

dynamic applyWatermark(bytes, context, {type: "png"}) async {
  var data = new Map();
  var prefs = await getUserWatermarkPreferences(context);
  data['bytes'] = bytes;
  data['type'] = type;
  data['prefs'] = prefs;
  final bdata = await rootBundle.load("assets/images/share_image.png");
  data['imageData'] =
      bdata.buffer.asUint8List(bdata.offsetInBytes, bdata.lengthInBytes);

  var res = await compute(applyWatermarkBg, data);

  return res;
}

dynamic applyWatermarkBg(data) async {
  var sharedImage;
  var prefs = data['prefs'];
  var type = data['type'];
  var bytes = data['bytes'];
  final imageData = data['imageData'];
  bool needUserLogo = prefs != null && prefs['userWatermark'] != "";
  bool needShareJoyLogo = prefs != null && prefs['sharejoyWatermark'] == true;
  if (!needUserLogo && !needShareJoyLogo) return bytes;
  try {
    if (type == "jpg") {
      sharedImage = decodeJpg(bytes);
    } else if (type == "png") {
      sharedImage = decodePng(bytes);
    } else {
      return bytes;
    }
  } catch (e) {
    return bytes;
  }
  if (needShareJoyLogo) {
    int watermarkWidth = (sharedImage.width * 0.25).round();

    var waterMarkImage = decodePng(imageData);
    waterMarkImage = copyResize(
      waterMarkImage,
      width: watermarkWidth,
    );
    sharedImage = drawImage(
      sharedImage,
      waterMarkImage,
      dstX: sharedImage.width -
          (waterMarkImage.width + (sharedImage.width * 0.05).round()),
      dstY: sharedImage.height -
          (waterMarkImage.height + (sharedImage.height * 0.05).round()),
      blend: true,
    );
  }
  if (needUserLogo) {
    sharedImage = drawString(
        sharedImage,
        arial_24,
        20,
        sharedImage.height - (30 + (sharedImage.height * 0.05).round()),
        prefs['userWatermark']);
  }

  return encodePng(sharedImage);
}
