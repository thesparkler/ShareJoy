import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/widgets/home/category_bar.dart';
import 'package:ShareJoy/widgets/home/post_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemesScreen extends StatelessWidget {
  final String type;
  final scroll = new ScrollController();
  final PostProvider memeProvider = PostProvider.instance();

  MemesScreen({Key key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    memeProvider.setType(this.type);
    memeProvider.setScrollController(scroll);
    print("building meme screen $type");
    return ChangeNotifierProvider.value(
      // lazy: false,
      value: memeProvider,

      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: SingleChildScrollView(
          controller: scroll,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  Config.titles[type],
                  style: TextStyle(
                      fontFamily: 'NunitoBold',
                      fontSize: 20.0,
                      color: Colors.black),
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .headline6
                  //     .copyWith(fontSize: 20.0)
                ),
                actions: [
                  // DropdownButton(items: null, onChanged: null)
                  LanguageButton(onChange: (v) {
                    print("$v language selected");
                    memeProvider.filter("lang", v);
                  }),
                ],
              ),
              CategoryBar(type: type),
              PostList(type: type)
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageButton extends StatefulWidget {
  final onChange;

  const LanguageButton({Key key, this.onChange}) : super(key: key);

  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  OverlayEntry _overlayEntry;

  final FocusNode _focusNode = FocusNode();
  bool shown = false;
  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
        shown = false;
      }
    });
    super.initState();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              right: 5.0,
              top: offset.dy + size.height + 5.0,
              width: 150.0,
              child: Material(
                elevation: 4.0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: Text('All'),
                      onTap: () => onChange(""),
                    ),
                    ListTile(
                      title: Text('English'),
                      onTap: () => onChange("english"),
                    ),
                    ListTile(
                      title: Text('Hindi'),
                      onTap: () => onChange("hindi"),
                    ),
                    ListTile(
                      title: Text('Marathi'),
                      onTap: () => onChange("marathi"),
                    )
                  ],
                ),
              ),
            ));
  }

  void onChange(String lang) {
    widget.onChange(lang);
    setState(() {
      shown = false;
    });
    this._overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusNode: _focusNode,
      color: Colors.black,
      icon: Icon(Icons.language),
      onPressed: () {
        if (shown) {
          this._overlayEntry.remove();
          setState(() {
            shown = false;
          });
        } else {
          this._overlayEntry = this._createOverlayEntry();
          Overlay.of(context).insert(this._overlayEntry);
          setState(() {
            shown = true;
          });
        }
      },
    );
  }
}
