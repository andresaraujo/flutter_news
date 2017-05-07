import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news/components/top_item_tile.dart';
import 'package:flutter_news/hn_api.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/pages/item_page.dart';


class TopItemsPage extends StatefulWidget {
  @override
  _TopItemsPageState createState() => new _TopItemsPageState();
}

class _TopItemsPageState extends State<TopItemsPage> {
  List<HnItem> _stories = [];

  initState() {
    super.initState();

    getTopStories().then((stories) {
      setState(() {
        _stories = stories;
      });
    });
  }

  buildNavItem(IconData icon, String title) {
    return new BottomNavigationBarItem(
        icon: new Icon(icon),
        title: new Text(title)
    );
  }

  @override
  Widget build(BuildContext context) {
    final storyListTiles = _stories.map((s) {
      return new TopItemTile(s, onTap: () => _onTapStory(s));
    }).toList();

    return new Scaffold(
        appBar: new AppBar(
          title: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 8.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(2.0),
                      border: new Border.all(
                        width: 2.0,
                        color: Colors.white,
                      )
                  ),
                  child: new Text('F'),
                ),
                new Text('Flutter News')
              ]
          ),
          elevation: Theme
              .of(context)
              .platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        bottomNavigationBar: new BottomNavigationBar(
            items: [
              buildNavItem(Icons.whatshot, 'Top'),
              buildNavItem(Icons.new_releases, 'New'),
              buildNavItem(Icons.view_compact, 'Show'),
              buildNavItem(Icons.question_answer, 'Ask'),
              buildNavItem(Icons.work, 'Jobs'),
            ]
        ),
        body: new RefreshIndicator(
            child: new ListView(
              children: storyListTiles,
            ),
            onRefresh: _onRefresh
        )
    );
  }

  Future<Null> _onRefresh() {
    return getTopStories().then((stories) {
      setState(() {
        _stories = stories;
      });
    });
  }

  void _onTapStory(HnItem story) {
    final page = new MaterialPageRoute(
        settings: new RouteSettings(name: '${story.title}'),
        builder: (_) => new ItemPage(story, index: _stories.indexOf(story))
    );
    Navigator.of(context).push(page);
  }
}

