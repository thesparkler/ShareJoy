import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/http_service.dart';
import 'package:ShareJoy/screens/favs_screen.dart';
import 'package:ShareJoy/screens/home_page.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  String lastQuery;
  List lastResults;
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? CustomTheme.placeHolder
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    print(query);
    if (query.length == 0) {
      return Center(child: Text("Type something and hit search"));
    }
    if (query == lastQuery) {
      return Results(res: lastResults);
    }
    return FutureBuilder(
        future: get(Config.baseUrl + "/search/" + query),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final res = snapshot.data.json();
            print(res);
            lastQuery = query;
            lastResults = res;
            return Results(res: res);
          }
        });
  }
}

class Results extends StatelessWidget {
  const Results({
    Key key,
    @required this.res,
  }) : super(key: key);

  final res;

  @override
  Widget build(BuildContext context) {
    if (null == res) {
      return Container();
    }
    return ListView.builder(
      itemCount: res.length,
      itemBuilder: (ctx, index) {
        final item = res[index];
        return ListTile(
          onTap: () => HomePage.route(
              context, item['type'], {"category_ids": item['id'].toString()}),
          title: RichText(
            text: TextSpan(
              text: item['name'] + " in ",
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                    text: Config.titles[item['type']],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
          subtitle: Text(item['other_names']),
        );
      },
    );
  }
}
