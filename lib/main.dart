
import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/pages/top_items_page/top_items_page.dart';

void main() {
  runApp(new FlutterNewsApp());
}

class FlutterNewsApp extends StatefulWidget {
  @override
  FlutterNewsAppState createState() => new FlutterNewsAppState();
}

class FlutterNewsAppState extends State<FlutterNewsApp> {
  // Default configuration
  FlutterNewsConfiguration _configuration = new FlutterNewsConfiguration(
    themeName: ThemeName.light,
  );

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
        home: new TopItemsPage(_configuration, configurationUpdater),
    );
  }
}
