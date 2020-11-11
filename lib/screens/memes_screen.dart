import 'dart:ui';
import 'package:ShareJoy/providers/meme_provider.dart';
import 'package:ShareJoy/widgets/filter_bar.dart';
import 'package:ShareJoy/widgets/home/category_bar.dart';
import 'package:ShareJoy/widgets/home/post_list.dart';
import 'package:ShareJoy/widgets/sharejoy_header_logo.dart';
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
        child: RefreshIndicator(
          onRefresh: () => memeProvider.refresh(),
          child: CustomScrollView(controller: scroll, slivers: <Widget>[
            SliverAppBar(
              shadowColor: Colors.black,
              forceElevated: true,
              floating: true,
              backgroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              )),
              title: const SharejoyHeaderLogo(),
              actions: [
                // DropdownButton(items: null, onChanged: null)
                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.filter_list_rounded),
                  onPressed: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0)
                        )
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => CategoryBar(provider: memeProvider),
                    );
                  },
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 8.0),
                //   child: LanguageButton(onChange: (v) {
                //     print("$v language selected");
                //     memeProvider.filter("lang", v);
                //   }),
                // ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 8.0,
                ),
                Container(
                    margin: EdgeInsets.only(left: 12.0), child: FilterBar()),
                PostList(type: type)
              ]),
            )
          ]),
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
  OverlayState _overlayState;
  bool _isVisible = false;

  //final FocusNode _focusNode = FocusNode();
  // bool shown = false;

  // @override
  // void initState() {
  //   _focusNode.addListener(() {
  //     if (_focusNode.hasFocus) {
  //       this._overlayEntry = this._createOverlayEntry();
  //       Overlay.of(context).insert(this._overlayEntry);
  //     } else {
  //       this._overlayEntry.remove();
  //       shown = false;
  //     }
  //   });
  //   super.initState();
  // }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          hideHelp();
        },
        child: Stack(
          children: [
            Positioned(
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
            ),
          ],
        ),
      ),
    );
  }

  void onChange(String lang) {
    widget.onChange(lang);
    setState(() {
      //shown = false;
      _isVisible = false;
    });
    this._overlayEntry.remove();
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   child: Container(
    //     margin: EdgeInsets.only(right: 10),
    //     child: Image.asset("assets/images/language.png", height: 25, width: 25),
    //   ),
    //   onTap: () {
    //     if (shown) {
    //       this._overlayEntry.remove();
    //       setState(() {
    //         shown = false;
    //       });
    //     } else {
    //       this._overlayEntry = this._createOverlayEntry();
    //       Overlay.of(context).insert(this._overlayEntry);
    //       setState(() {
    //         shown = true;
    //       });
    //     }
    //   },
    // );
    //

    return Row(
      children: [
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Image.asset("assets/images/language.png",
                height: 25, width: 25),
          ),
          onTap: () {
            showLang();
          },
        )
      ],
    );
  }

  showLang() async {
    if (!_isVisible) {
      _overlayState = Overlay.of(context);
      _overlayEntry = _createOverlayEntry();
      _overlayState.insert(_overlayEntry);
      _isVisible = true;
    }
  }

  void hideHelp() {
    _isVisible = false;
    _overlayEntry.remove();
  }
}
