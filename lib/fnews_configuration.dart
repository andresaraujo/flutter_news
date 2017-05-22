import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeName { light, dark }

const ThemeName defaultTheme = ThemeName.light;

Future<Null>  storeThemeToPrefs(ThemeName themeName) async {
  assert(themeName != null);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    ThemeName themeName;
    final String themeString = prefs.getString('theme') ?? defaultTheme.toString();

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
