import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeName { light, dark }

const defaultTheme = ThemeName.light;

const prefsKeyTheme = "theme";
const prefsKeyShowFullComment = "showFullComment";
const prefsKeyExpandCommentTree = "expandCommentTree";

Future<Null> storeThemeToPrefs(ThemeName themeName) async {
  assert(themeName != null);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(prefsKeyTheme, themeName.toString());
}

Future<Null> storeShowFullCommentToPrefs(bool showFullComment) async {
  assert(showFullComment != null);
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(prefsKeyShowFullComment, showFullComment);
}

Future<Null> storeExpandCommentTreeToPrefs(bool expandCommentTree) async {
  assert(expandCommentTree != null);
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(prefsKeyExpandCommentTree, expandCommentTree);
}

class FlutterNewsConfiguration {
  FlutterNewsConfiguration({
    @required this.themeName,
    @required this.showFullComment,
    @required this.expandCommentTree,
  }) {
    assert(themeName != null);
    assert(showFullComment != null);
    assert(expandCommentTree != null);
  }

  final ThemeName themeName;
  final bool showFullComment;
  final bool expandCommentTree;

  FlutterNewsConfiguration copyWith(
      {ThemeName themeName, bool showFullComment, bool expandCommentTree}) {
    return new FlutterNewsConfiguration(
      themeName: themeName ?? this.themeName,
      showFullComment: showFullComment ?? this.showFullComment,
      expandCommentTree: expandCommentTree ?? this.expandCommentTree,
    );
  }

  static Future<FlutterNewsConfiguration> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve theme name
    ThemeName themeName;
    final themeString =
        prefs.getString(prefsKeyTheme) ?? defaultTheme.toString();

    switch (themeString) {
      case 'ThemeName.dark':
        themeName = ThemeName.dark;
        break;
      case 'ThemeName.light':
      default:
        themeName = ThemeName.light;
        break;
    }

    // Retrieve show full comment setting
    final showFullComment = prefs.getBool(prefsKeyShowFullComment) ?? false;

    // Retrieve expand comments setting
    final expandCommentTree = prefs.getBool(prefsKeyExpandCommentTree) ?? false;

    return new FlutterNewsConfiguration(
      themeName: themeName,
      showFullComment: showFullComment,
      expandCommentTree: expandCommentTree,
    );
  }
}
