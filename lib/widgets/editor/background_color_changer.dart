import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BackgroundColorChanger extends StatelessWidget {
  final Function onChanged;
  final Color selectedValue;
  const BackgroundColorChanger({
    Key key,
    this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        height: 100.0,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: Colors.primaries
                    .map((e) => InkWell(
                          onTap: () => onChanged(e),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: e,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            InkWell(
              onTap: () => _customPicker(context),
              child: Container(
                  margin: EdgeInsets.all(10.0),
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    MdiIcons.formatColorHighlight,
                  )),
            ),
          ],
        ));
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
                      child: Text("Pick Color"),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.clear),
                    ),
                  ],
                ),
                ColorPicker(
                  pickerColor: Colors.black,
                  onColorChanged: onChanged,
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
}
