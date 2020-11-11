import 'package:flutter/material.dart';

class RadioGroupButton extends StatefulWidget {
  final Function onSelected;
  final List<Widget> children;
  final int selected;

  const RadioGroupButton(
      {Key key, this.onSelected, this.children, this.selected})
      : super(key: key);

  @override
  _RadioGroupButtonState createState() => _RadioGroupButtonState();
}

class _RadioGroupButtonState extends State<RadioGroupButton> {
  int selected;

  @override
  void initState() {
    selected = widget.selected;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < widget.children.length; i++) {
      children.add(
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onSelected(i);
              setState(() {
                selected = i;
              });
            },
            child: Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                color: selected == i ? Colors.red[100] : Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: widget.children[i],
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: children);
  }
}
