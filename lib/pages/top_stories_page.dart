import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news/components/story_list_tile.dart';
import 'package:flutter_news/hn_api.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/pages/story_page.dart';


class TopStoriesPage extends StatefulWidget {
  @override
  _TopStoriesPageState createState() => new _TopStoriesPageState();
}

class _TopStoriesPageState extends State<TopStoriesPage> {
  List<Item> _stories = [];

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
      return new StoryListTile(s, onTap: () => _onTapStory(s));
    }).toList();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter News'),
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

  void _onTapStory(Item story) {
    final page = new MaterialPageRoute(
        settings: new RouteSettings(name: '${story.title}'),
        builder: (_) => new StoryPage(_stories.indexOf(story), story)
    );
    Navigator.of(context).push(page);
  }
}

