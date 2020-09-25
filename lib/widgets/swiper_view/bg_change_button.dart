import 'package:Meme/config.dart';
import 'package:Meme/models/post.dart';
import 'package:Meme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BGChangeButton extends StatelessWidget {
  final Post item;
  final Function onChange;
  const BGChangeButton({Key key, this.item, this.onChange}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).showBottomSheet((context) => Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              // color: Colors.blue,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MaterialButton(
                              onPressed: () => _customPicker(context),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              child: Text("Pick Custom Color"),
                            ),
                            CustomTheme.w8,
                            MaterialButton(
                              onPressed: () => _customImagePicker(context),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              child: Text("Pick Image"),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.clear)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: Colors.black,
                        onColorChanged: (v) => onChange(v, null),
                      ),
                    ),
                  ),
                  // ColorPicker(
                  //   pickerColor: Colors.black,
                  //   onColorChanged: onChange,

                  // )
                ],
              ),
            ));
      },
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  void _customPicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Pick Image"),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.clear),
                    ),
                  ],
                ),
                ColorPicker(
                  pickerColor: Colors.black,
                  onColorChanged: (v) => onChange(v, null),
                  colorPickerWidth: 300.0,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: true,
                  displayThumbColor: true,
                  showLabel: true,
                  paletteType: PaletteType.hsv,
                  pickerAreaBorderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(2.0),
                    topRight: const Radius.circular(2.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _customImagePicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
              child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Pick Image"),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 3.0),
                itemCount: 28,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () => onChange(Colors.primaries[0], null),
                      child: Container(
                        color: Colors.grey,
                        width: 100.0,
                        height: 100.0,
                        child: Center(
                            child: Text(
                          "No Image",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => onChange(
                      Colors.black,
                      DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          Config.host + "/images/backgrounds/$index.jpg",
                        ),
                      ),
                    ),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      child: Image.network(
                          Config.host + "/images/backgrounds/$index.jpg",
                          fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ],
          )),
        );
      },
    );
  }
}
