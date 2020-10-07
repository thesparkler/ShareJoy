import 'package:ShareJoy/theme_data.dart';
import 'package:flutter/material.dart';

class TextSizeChanger extends StatefulWidget {
  final onChanged;
  final double selectedValue;
  const TextSizeChanger({
    Key key,
    this.onChanged,
    this.selectedValue,
  }) : super(key: key);

  @override
  _TextSizeChangerState createState() => _TextSizeChangerState();
}

class _TextSizeChangerState extends State<TextSizeChanger> {
  double value;
  @override
  Widget build(BuildContext context) {
    if (value == null) value = widget.selectedValue;
    return Container(
      height: 100.0,
      child: Row(
        children: [
          Expanded(
            child: Slider(
              onChanged: (double v) {
                setState(() {
                  value = v;
                  widget.onChanged(v);
                });
              },
              min: 9,
              max: 140,
              value: value,
            ),
          ),
          Text(value.roundToDouble().toString()),
          CustomTheme.w12
        ],
      ),
    );
  }
}
