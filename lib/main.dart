import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/i18n/fnews_messages_all.dart';
import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/module/stories/stories_view.dart';

void main() {
  // Injector for selecting data source: Environment.production or Environment.mock
  Injector.configure(Environment.production);
  runApp(new FlutterNewsApp());
}

class FlutterNewsApp extends StatefulWidget {
  @override
  FlutterNewsAppState createState() => new FlutterNewsAppState();
}

class FlutterNewsAppState extends State<FlutterNewsApp> {
  // Default configuration
  var _configuration = new FlutterNewsConfiguration(
    themeName: ThemeName.light,
    showFullComment: false,
    expandCommentTree: false,
  );

  @override
  void initState() {
    super.initState();

    // Load configuration from shared preferences
    FlutterNewsConfiguration
        .loadFromPrefs()
        .then((FlutterNewsConfiguration config) {
      if (mounted) {
        configurationUpdater(config);
      }
    });
  }

  // App theme settings
  ThemeData get theme {
    assert(_configuration.themeName != null);
    switch (_configuration.themeName) {
      case ThemeName.light:
        return new ThemeData(
            brightness: Brightness.light, primarySwatch: Colors.orange);
      case ThemeName.dark:
        return new ThemeData(
            brightness: Brightness.dark, accentColor: Colors.orangeAccent);
    }
    return null;
  }

  void configurationUpdater(FlutterNewsConfiguration value) {
    setState(() {
      _configuration = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: theme,
      home: new HnStoriesPage(_configuration, configurationUpdater),
    );
  }
}
