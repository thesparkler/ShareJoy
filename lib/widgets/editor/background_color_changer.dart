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
    var primaries = [Colors.white];
    primaries.addAll(Colors.primaries);
    return Container(
        // color: Colors.red,
        height: 100.0,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: primaries
                    .map((e) => InkWell(
                          onTap: () => onChanged(e),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: e,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                const BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.5,
                                  offset: Offset(-1, 1),
                                ),
                                const BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.5,
                                  offset: Offset(1, 1),
                                )
                              ],
                              // border: Border.all(color: Colors.black),
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
    Scaffold.of(context).showBottomSheet((context) {
      return Container(
        child: SingleChildScrollView(
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
                pickerColor: selectedValue,
                onColorChanged: onChanged,
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 0.4,
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
    });
  }
}
