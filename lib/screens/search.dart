import 'dart:async';

import 'package:ShareJoy/config.dart';
import 'package:ShareJoy/http_service.dart';
import 'package:ShareJoy/screens/home_page.dart';
import 'package:ShareJoy/theme_data.dart';
import 'package:flutter/material.dart';

class Debouncer<T> {
  Debouncer(this.duration, this.onValue);
  final Duration duration;
  void Function(T value) onValue;
  T _value;
  Timer _timer;
  T get value => _value;
  set value(T val) {
    _value = val;
    _timer?.cancel();
    _timer = Timer(duration, () => onValue(_value));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() {
    debouncer = Debouncer<String>(Duration(milliseconds: 500), (value) async {
      completer.complete(await get(Config.baseUrl + "/search/" + value));
    });
  }
  String lastQuery;
  List lastResults;
  Completer<Response> completer = Completer<Response>();
  Debouncer debouncer;
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
    print(query);
    if (query.length == 0) {
      return Center(child: Text("Type something and hit search"));
    }
    if (query == lastQuery) {
      return Results(res: lastResults);
    }
    completer = Completer<Response>();

    debouncer.value = query;

    return FutureBuilder(
        future: completer.future,
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
          onTap: () {
            print(item['id']);
            HomePage.route(
                context, item['type'], {"category_ids": item['id'].toString()});
          },
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
