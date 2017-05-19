import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeName { light, dark }

const defaultTheme = ThemeName.light;

storeThemeToPrefs(ThemeName themeName) async {
  assert(themeName != null);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("theme", themeName.toString());
}

class FlutterNewsConfiguration {
  FlutterNewsConfiguration({@required this.themeName}) {
    assert(themeName != null);
  }

  final ThemeName themeName;

  FlutterNewsConfiguration copyWith({ThemeName themeName}) {
    return new FlutterNewsConfiguration(themeName: themeName ?? this.themeName);
  }

  static Future<FlutterNewsConfiguration> loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ThemeName themeName;
    String themeString = prefs.getString('theme') ?? defaultTheme.toString();

    switch (themeString) {
      case 'ThemeName.dark':
        themeName = ThemeName.dark;
        break;
      case 'ThemeName.light':
      default:
        themeName = ThemeName.light;
        break;
    }

    return new FlutterNewsConfiguration(themeName: themeName);
  }
}
