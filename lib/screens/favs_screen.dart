import 'dart:convert';
import 'dart:ui';

import 'package:ShareJoy/local_storage.dart';
import 'package:ShareJoy/models/post.dart';
import 'package:ShareJoy/screens/single_swiper_view.dart';
import 'package:ShareJoy/widgets/home/post_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavsScreen extends StatefulWidget {
  static route(context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavsScreen(),
      ),
    );
  }

  @override
  _FavsScreenState createState() => _FavsScreenState();
}

class _FavsScreenState extends State<FavsScreen> {
  List<Post> likedPosts = [];
  var likes_array;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    Map likes = await LocalStorage.instance.get("likes");
    likes_array = await LocalStorage.instance.get("likes_array");
    likedPosts = [];
    likes.forEach((key, value) {
      print(value);
      value = json.decode(value);
      print("decoded");
      print(value);
      likedPosts.add(Post.fromJSON(value));
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text("Favorites", style: TextStyle(color: Colors.black),),
      ),
      body: likedPosts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : likedPosts.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/likes_folder.png", height: 150, width: 150,),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text("No Favorites", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text("Items you mark as favorite \n  are shown here", style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: likedPosts.length,
                  itemBuilder: (context, index) {
                    final item = likedPosts[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Scaffold(body: DetailView(item: item))));
                        initialize();
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom: 10.0,
                                top: 5.0),
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.transparent, width: 0.5),
                                  borderRadius: BorderRadius.circular(15)),
                              child: item.renderType == "image"
                                  ? ImagePost(item: item)
                                  : TextPost(item: item),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),


    );
  }
}
