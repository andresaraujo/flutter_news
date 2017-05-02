import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news/components/story_list_tile.dart';
import 'package:flutter_news/hn_api.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/pages/story_page.dart';


class TopStoriesPage extends StatefulWidget {
  @override
  _NewsPageState createState() => new _NewsPageState();
}

class _NewsPageState extends State<TopStoriesPage> {
  List<Item> _stories = [];

  initState() {
    super.initState();

    getTopStories().then((stories) {
      setState(() {
        _stories = stories;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final storyListTiles = _stories.map((s) {
      return new StoryListTile(s, onTap: () => _onTapStory(s));
    }).toList();

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Flutter News')
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

