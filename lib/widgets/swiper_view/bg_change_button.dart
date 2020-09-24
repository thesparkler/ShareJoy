import 'package:Meme/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                        MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titlePadding: const EdgeInsets.all(0.0),
                                  contentPadding: const EdgeInsets.all(0.0),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: Colors.black,
                                      onColorChanged: onChange,
                                      colorPickerWidth: 300.0,
                                      pickerAreaHeightPercent: 0.7,
                                      enableAlpha: true,
                                      displayThumbColor: true,
                                      showLabel: true,
                                      paletteType: PaletteType.hsv,
                                      pickerAreaBorderRadius:
                                          const BorderRadius.only(
                                        topLeft: const Radius.circular(2.0),
                                        topRight: const Radius.circular(2.0),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          child: Text("Pick Custom Color"),
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
                        onColorChanged: onChange,
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
}
