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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<int> _itemIds = <int>[];
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();

    // Show RefreshIndicator
    final Future<Null> load = new Future<Null>.value(null);
    load.then((_) {
      _refreshIndicatorKey.currentState.show();
    });

    // Load Top stories
    getTopStoryIds().then((List<int> storyIds) {
      setState(() {
        _itemIds = storyIds;
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

    return new Row(children: <Widget>[
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

  Widget _buildBody(BuildContext context) {
    final EdgeInsets padding = const EdgeInsets.all(8.0);

    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: new CustomScrollView(
        slivers: <Widget>[
          new SliverPadding(
            padding: padding,
            sliver: new SliverList(
              delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final int storyId = _itemIds[index];
                  return new TopItemTile(
                    storyId,
                  );
                },
                childCount: _itemIds.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: _buildAppTitle(context),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
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
      body: _buildBody(context),
    );
  }

  Future<Null> _onRefresh({int navIndex}) async {
    navIndex ??= _selectedNavIndex;
    final NavTypes navType = NavTypes.values[navIndex];
    List<int> items = <int>[];

    setState(() {
      _itemIds = items;
      _selectedNavIndex = navIndex;
    });

    switch (navType) {
      case NavTypes.topStories:
        items = await getTopStoryIds();
        break;
      case NavTypes.newStories:
        items = await getNewStoryIds();
        break;
      case NavTypes.showStories:
        items = await getShowStoryIds();
        break;
      case NavTypes.askStories:
        items = await getAskStoryIds();
        break;
      case NavTypes.jobStories:
        items = await getJobStoryIds();
        break;
    }

    setState(() {
      _itemIds = items;
    });
  }

  Future<Null> _handleNavChange(int value) async {
    if (value == _selectedNavIndex) return;

    _refreshIndicatorKey.currentState.show();

    _onRefresh(navIndex: value);
  }
}
