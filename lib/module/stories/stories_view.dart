import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/fnews_strings.dart';
import 'package:flutter_news/model/hn_stories.dart';

import 'package:flutter_news/module/stories/item_view.dart';
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

  StoriesListPresenter _presenter;

  HnStories _stories;
  int _storyCount;
  int _selectedNavIndex;
  bool _forceReloadOnRefresh;

  HnStoriesPageState() {
    _presenter = new StoriesListPresenter(this);

    _stories = new HnStories(storyType: StoryType.top, storyList: <int>[]);
    _storyCount = 0;
    _selectedNavIndex = 0;

    // If not refreshed by navChange, ignore story cache
    _forceReloadOnRefresh = true;
  }

  @override
  void initState() {
    super.initState();

    // Show RefreshIndicator
    // This will call onRefresh() method and load stories
    final load = new Future<Null>.value(null);
    load.then((_) {
      _refreshIndicatorKey.currentState.show();
    });
  }

  @override
  void onLoadStoriesComplete(HnStories stories) {
    if (mounted) {
      setState(() {
        _stories = stories;
        _storyCount = stories.storyList.length;
      });
    }
  }

  @override
  void onLoadStoriesError() {
    // TODO: implement onLoadStoriesError
  }

  void _handleThemeChange(bool darkTheme) {
    final theme = darkTheme ? ThemeName.dark : ThemeName.light;
    storeThemeToPrefs(theme);

    if (widget.updater != null)
      widget.updater(widget.configuration.copyWith(themeName: theme));
  }

  void _handleShowFullCommentChange(bool showFullComment) {
    storeShowFullCommentToPrefs(showFullComment);

    if (widget.updater != null)
      widget.updater(
          widget.configuration.copyWith(showFullComment: showFullComment));
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String title) {
    return new BottomNavigationBarItem(
      icon: new Icon(icon),
      title: new Text(title),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    final titleColor = (widget.configuration.themeName == ThemeName.light)
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
            title: const Text('Night mode'),
            trailing: new Switch(
              value: widget.configuration.themeName == ThemeName.dark,
              onChanged: _handleThemeChange,
            ),
          ),
          const Divider(),
          new ListTile(
            title: const Text('Show full comments'),
            trailing: new Switch(
              value: widget.configuration.showFullComment,
              onChanged: _handleShowFullCommentChange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final padding = const EdgeInsets.all(8.0);

    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      child: new ListView.builder(
        padding: padding,
        itemCount: _storyCount,
        itemBuilder: (BuildContext context, int index) {
          final int storyId = _stories.storyList[index];
          return new ItemTile(storyId, widget.configuration);
        },
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
    final NavTypes selectedNav = NavTypes.values[_selectedNavIndex];

    setState(() {
      _stories = new HnStories(storyType: StoryType.top, storyList: <int>[]);
      _storyCount = 0;
    });

    switch (selectedNav) {
      case NavTypes.newStories:
        _presenter.loadStories(StoryType.newest, _forceReloadOnRefresh);
        break;
      case NavTypes.showStories:
        _presenter.loadStories(StoryType.show, _forceReloadOnRefresh);
        break;
      case NavTypes.askStories:
        _presenter.loadStories(StoryType.ask, _forceReloadOnRefresh);
        break;
      case NavTypes.jobStories:
        _presenter.loadStories(StoryType.job, _forceReloadOnRefresh);
        break;
      case NavTypes.topStories:
      default:
        _presenter.loadStories(StoryType.top, _forceReloadOnRefresh);
        break;
    }

    // Unless refreshed by navChange, always ignore story cache
    _forceReloadOnRefresh = true;

    // onLoadStoriesComplete calls setState afterwards
  }

  void _handleNavChange(int value) {
    if (value == _selectedNavIndex) {
      return;
    }

    _selectedNavIndex = value;
    _forceReloadOnRefresh = false;

    // This will show refresh indicator and call onRefresh()
    _refreshIndicatorKey.currentState.show();
  }
}
