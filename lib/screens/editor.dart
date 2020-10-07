import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/providers/editor_provider.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:ShareJoy/widgets/editor/background_color_changer.dart';
import 'package:ShareJoy/widgets/editor/background_image_changer.dart';
import 'package:ShareJoy/widgets/editor/font_size_changer.dart';
import 'package:ShareJoy/widgets/swiper_view/download_button.dart';
import 'package:ShareJoy/widgets/swiper_view/share_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class Editor extends StatelessWidget {
  final Post item;
  static route(BuildContext context, Post item) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Editor(item: item),
    ));
  }

  final GlobalKey _key = new GlobalKey();

  Editor({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => EditorProvider(item),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButton(),
                  Spacer(),
                  DownlaodButton(
                    item: item,
                    rKey: _key,
                    color: Colors.black,
                  ),
                  ShareButton(
                    item: item,
                    rKey: _key,
                    color: Colors.black,
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Consumer<EditorProvider>(builder: (context, ep, chld) {
                      return RepaintBoundary(
                        key: _key,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: ep.bgColor,
                              image: ep.imageUrl != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        ep.imageUrl,
                                      ),
                                    )
                                  : null),
                          child: Center(
                            child: Text(
                              item.caption,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    color: ep.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ep.size,
                                  ),
                            ),
                          ),
                        ),
                      );
                    })),
              ),
              ToolBar()
            ],
          ),
        ),
      ),
    );
  }
}

class ToolBar extends StatefulWidget {
  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> with TickerProviderStateMixin {
  TabController ctrl;
  EditorProvider ep;

  @override
  void initState() {
    ep = Provider.of<EditorProvider>(context, listen: false);
    ctrl = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.black,
          // onTap: (int index) {
          //   print("index clicked");
          // },
          controller: ctrl,
          tabs: [
            Tab(child: Icon(MdiIcons.formatSize)),
            Tab(child: Icon(MdiIcons.imageEdit)),
            Tab(child: Icon(MdiIcons.formatColorFill)),
            Tab(child: Icon(MdiIcons.formatColorText)),
          ],
        ),
        Container(
          height: 100.0,
          child: TabBarView(controller: ctrl, children: [
            TextSizeChanger(
              onChanged: ep.changeTextSize,
              selectedValue: ep.size,
            ),
            BackgroundImageChanger(
              selectedValue: ep.imageUrl,
              onChanged: ep.changeBackgroundImage,
            ),
            BackgroundColorChanger(
              selectedValue: ep.bgColor,
              onChanged: ep.changeBackgroundColor,
            ),
            BackgroundColorChanger(
              selectedValue: ep.textColor,
              onChanged: ep.changeTextColor,
            ),
            // FontFamilyChanger(),
          ]),
        )
      ],
    );
  }
}

class FontFamilyChanger extends StatelessWidget {
  const FontFamilyChanger({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 100.0,
    );
  }
}
