import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeName { light, dark }

Future<FlutterNewsConfiguration> loadConfigFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String themeString = prefs.getString('theme') ?? "light";

  ThemeName tn;

  switch (themeString) {
    case 'dark':
      tn = ThemeName.dark;
      break;
    case 'light':
      tn = ThemeName.light;
      break;
    default:
      tn = ThemeName.light;
      break;
  }

  return new FlutterNewsConfiguration(themeName: tn);
}

class FlutterNewsConfiguration {
  FlutterNewsConfiguration({@required this.themeName}) {
    assert(themeName != null);
  }

  final ThemeName themeName;

  FlutterNewsConfiguration copyWith({ThemeName themeName}) {
    return new FlutterNewsConfiguration(themeName: themeName ?? this.themeName);
  }

}
