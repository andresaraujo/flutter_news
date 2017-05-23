import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/fnews_strings.dart';
import 'package:flutter_news/model/hn_story.dart';

import 'package:flutter_news/module/stories/item/item_view.dart';
import 'stories_presenter.dart';

enum NavTypes { topStories, newStories, showStories, askStories, jobStories }

class HnStoriesPage extends StatefulWidget {
  const HnStoriesPage(this.configuration, this.updater);

  final FlutterNewsConfiguration configuration;
  final ValueChanged<FlutterNewsConfiguration> updater;

  @override
  HnStoriesPageState createState() => new HnStoriesPageState();
}

class HnStoriesPageState extends State<HnStoriesPage>
    implements StoriesListViewContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<HnStory> _items = <HnStory>[];
  int _itemCount = 0;
  int _selectedNavIndex = 0;

  StoriesListPresenter _presenter;

  HnStoriesPageState() {
    _presenter = new StoriesListPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    // Show RefreshIndicator
    // This will call onRefresh() method and load stories
    final Future<Null> load = new Future<Null>.value(null);
    load.then((_) {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void onLoadStoriesComplete(List<HnStory> items) {
    if (mounted) {
      setState(() {
        _items = items;
        _itemCount = items.length;
      });
    }
  }

  @override
  void onLoadStoriesError() {
    // TODO: implement onLoadStoriesError
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
                  final int storyId = _items[index].storyId;
                  return new ItemTile(storyId);
                },
                childCount: _itemCount,
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

  Future<Null> _onRefresh() async {
    print("onRefresh");
    final NavTypes selectedNav = NavTypes.values[_selectedNavIndex];

    setState(() {
      _items = <HnStory>[];
    });

    switch (selectedNav) {
      case NavTypes.newStories:
        _presenter.loadStories(StoryType.newest);
        break;
      case NavTypes.showStories:
        _presenter.loadStories(StoryType.show);
        break;
      case NavTypes.askStories:
        _presenter.loadStories(StoryType.ask);
        break;
      case NavTypes.jobStories:
        _presenter.loadStories(StoryType.job);
        break;
      case NavTypes.topStories:
      default:
        _presenter.loadStories(StoryType.top);
        break;
    }

    // onLoadStoriesComplete calls setState afterwards
  }

  void _handleNavChange(int value) {
    if (value == _selectedNavIndex) {
      return;
    }

    _selectedNavIndex = value;

    // This will show refresh indicator and call onRefresh()
    _refreshIndicatorKey.currentState.show();
  }
}
