import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news/pages/top_items_page/top_item_tile.dart';
import 'package:flutter_news/hn_api.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/pages/item_page/item_page.dart';

enum NavTypes {
  topStories,
  newStories,
  showStories,
  askStories,
  jobStories
}


class TopItemsPage extends StatefulWidget {
  @override
  _TopItemsPageState createState() => new _TopItemsPageState();
}

class _TopItemsPageState extends State<TopItemsPage> {
  List<HnItem> _items = [];
  int _selectedNavIndex = 0;

  initState() {
    super.initState();

    getTopStories().then((stories) {
      setState(() {
        _items = stories;
      });
    });
  }

  buildNavItem(IconData icon, String title) {
    return new BottomNavigationBarItem(
      icon: new Icon(icon),
      title: new Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = new Row(
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
    );

    final itemTiles = _items.map((s) {
      return new TopItemTile(s, onTap: () => _onTapItem(s));
    }).toList();

    return new Scaffold(
        appBar: new AppBar(
          title: appTitle,
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
          ],
          currentIndex: _selectedNavIndex,
          onTap: _handleNavChange,
        ),
        body: new RefreshIndicator(
            child: new ListView(
              children: itemTiles,
            ),
            onRefresh: _onRefresh
        )
    );
  }

  Future<Null> _onRefresh({int navIndex}) async {
    navIndex ??= _selectedNavIndex;
    final navType = NavTypes.values[navIndex];
    var items = <HnItem>[];

    setState(() {
      _items = items;
      _selectedNavIndex = navIndex;
    });

    switch (navType) {
      case NavTypes.topStories:
        items = await getTopStories();
        break;
      case NavTypes.newStories:
        items = await getNewStories();
        break;
      case NavTypes.showStories:
        items = await getShowStories();
        break;
      case NavTypes.askStories:
        items = await getAskStories();
        break;
      case NavTypes.jobStories:
        items = await getJobStories();
        break;
    }

    setState(() {
      _items = items;
    });
  }

  void _onTapItem(HnItem story) {
    final page = new MaterialPageRoute(
        settings: new RouteSettings(name: '${story.title}'),
        builder: (_) => new ItemPage(story)
    );
    Navigator.of(context).push(page);
  }

  _handleNavChange(int value) async {
    if (value == _selectedNavIndex) return;

    _onRefresh(navIndex: value);
  }
}

