import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/widgets/watermark_alert.dart';
import 'package:flutter/material.dart';

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
