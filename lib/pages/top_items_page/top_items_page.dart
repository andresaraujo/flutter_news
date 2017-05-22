import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/fnews_strings.dart';
import 'package:flutter_news/pages/top_items_page/top_item_tile.dart';
import 'package:flutter_news/hn_api.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/pages/item_page/item_page.dart';

enum NavTypes { topStories, newStories, showStories, askStories, jobStories }

class TopItemsPage extends StatefulWidget {
  const TopItemsPage(this.configuration, this.updater);

  final FlutterNewsConfiguration configuration;
  final ValueChanged<FlutterNewsConfiguration> updater;

  @override
  TopItemsPageState createState() => new TopItemsPageState();
}

class TopItemsPageState extends State<TopItemsPage> {
  List<HnItem> _items = <HnItem>[];
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();

    getTopStories().then((List<HnItem> stories) {
      setState(() {
        _items = stories;
      });
    });
  }

  void _handleThemeChange(ThemeName themeName) {
    storeThemeToPrefs(themeName);

    if (widget.updater != null)
      widget.updater(widget.configuration.copyWith(themeName: themeName));
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String title) {
    return new BottomNavigationBarItem(
      icon: new Icon(icon),
      title: new Text(title),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    final Color titleColor = (widget.configuration.themeName == ThemeName.light)
        ? Colors.white
        : Colors.orange;

    return new Row(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(2.0),
                border: new Border.all(
                  width: 2.0,
                  color: titleColor,
                )),
            child: new Text('F', style: new TextStyle(color: titleColor)),
          ),
          new Text(FlutterNewsStrings.of(context).title(),
              style: new TextStyle(color: titleColor))
        ]);
  }

  Widget _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
              child: new Center(
                  child: new Text(FlutterNewsStrings.of(context).title()))),
          new ListTile(
            title: const Text('Light Theme'),
            trailing: new Radio<ThemeName>(
              value: ThemeName.light,
              groupValue: widget.configuration.themeName,
              onChanged: _handleThemeChange,
            ),
            onTap: () {
              _handleThemeChange(ThemeName.light);
            },
          ),
          new ListTile(
            title: const Text('Dark Theme'),
            trailing: new Radio<ThemeName>(
              value: ThemeName.dark,
              groupValue: widget.configuration.themeName,
              onChanged: _handleThemeChange,
            ),
            onTap: () {
              _handleThemeChange(ThemeName.dark);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TopItemTile> itemTiles = _items.map((HnItem s) {
      return new TopItemTile(s, onTap: () => _onTapItem(s));
    }).toList();

    return new Scaffold(
        appBar: new AppBar(
          title: _buildAppTitle(context),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        drawer: _buildDrawer(context),
        bottomNavigationBar: new BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            _buildNavItem(Icons.whatshot, 'Top'),
            _buildNavItem(Icons.new_releases, 'New'),
            _buildNavItem(Icons.view_compact, 'Show'),
            _buildNavItem(Icons.question_answer, 'Ask'),
            _buildNavItem(Icons.work, 'Jobs'),
          ],
          currentIndex: _selectedNavIndex,
          onTap: _handleNavChange,
        ),
        body: new RefreshIndicator(
            child: new ListView(
              children: itemTiles,
            ),
            onRefresh: _onRefresh));
  }

  Future<Null> _onRefresh({int navIndex}) async {
    navIndex ??= _selectedNavIndex;
    final NavTypes navType = NavTypes.values[navIndex];
    List<HnItem> items = <HnItem>[];

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
    final MaterialPageRoute<Null> page = new MaterialPageRoute<Null>(
      settings: new RouteSettings(name: '${story.title}'),
      builder: (_) => new ItemPage(story),
    );
    Navigator.of(context).push(page);
  }

  Future<Null> _handleNavChange(int value) async {
    if (value == _selectedNavIndex) return;

    _onRefresh(navIndex: value);
  }
}
