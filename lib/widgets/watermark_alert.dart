import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:flutter/material.dart';

class WatermarkAlert extends StatefulWidget {
  final Function onSubmit;
  const WatermarkAlert({
    Key key,
    this.onSubmit,
  }) : super(key: key);

  @override
  _WatermarkAlertState createState() => _WatermarkAlertState();
}

class _WatermarkAlertState extends State<WatermarkAlert> {
  TextEditingController txtCtrl = TextEditingController();
  bool watarmarkSharejoyLogo = true;
  String watermarkUserText;

  @override
  void initState() {
    initStorage();
    super.initState();
  }

  void initStorage() async {
    var prefs = await LocalStorage.instance.get("watermark_prefs");
    if (prefs != null) {
      print(prefs);
      watermarkUserText = prefs['userWatermark'] ?? "";
      watarmarkSharejoyLogo = prefs['sharejoyWatermark'] ?? true;
      txtCtrl.text = watermarkUserText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // titlePadding: EdgeInsets.all(20.0),
      title: Text("Watermark your Image"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "You can change watermark settings from settings screen",
              style: TextStyle(color: Colors.grey, fontSize: 11.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                  value: watarmarkSharejoyLogo,
                  onChanged: (b) {
                    setState(() {
                      watarmarkSharejoyLogo = b;
                    });
                  }),
              Text("Add Sharejoy Watermark"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Please help us to spread by adding our watermark to your shared images",
              style: TextStyle(fontSize: 9.0),
            ),
          ),
          CustomTheme.h16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("Add Your Name Watermark"),
          ),
          CustomTheme.h8,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 30.0,
            child: TextField(
              controller: txtCtrl,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  border: OutlineInputBorder(),
                  hintText: "Your Watermark Text"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    padding: EdgeInsets.all(3.0),
                    onPressed: () {
                      watermarkUserText = txtCtrl.text;
                      widget.onSubmit(watermarkUserText, watarmarkSharejoyLogo);
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      "Save this Settings",
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                CustomTheme.w4,
                OutlineButton(
                  padding: EdgeInsets.all(3.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
