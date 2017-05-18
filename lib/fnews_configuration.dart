import 'package:flutter/foundation.dart';

enum ThemeName { light, dark }

class FlutterNewsConfiguration {
  FlutterNewsConfiguration({@required this.themeName}) {
    assert(themeName != null);
  }

  final ThemeName themeName;

  FlutterNewsConfiguration copyWith({ThemeName themeName}) {
    return new FlutterNewsConfiguration(themeName: themeName ?? this.themeName);
  }
}
