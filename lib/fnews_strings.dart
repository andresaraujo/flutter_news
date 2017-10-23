import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news/i18n/fnews_messages_all.dart';

// Wrappers for strings that are shown in the UI.  The strings can be
// translated for different locales using the Dart intl package.
//
// Locale-specific values for the strings live in the i18n/*.arb files.
//
// To generate the fnews_messages_*.dart files from the ARB files, run:
// pub global run intl_translation:generate_from_arb --output-dir=lib/i18n --generated-file-prefix=fnews_ --no-use-deferred-loading lib/fnews_strings.dart lib/i18n/fnews_*.arb

class FlutterNewsStrings {
  FlutterNewsStrings(Locale locale) : _localeName = locale.toString();

  final String _localeName;

  static Future<FlutterNewsStrings> load(Locale locale) {
    return initializeMessages(locale.toString())
        .then((_) {
          return new FlutterNewsStrings(locale);
        });
  }

  static FlutterNewsStrings of(BuildContext context) {
    return Localizations.of<FlutterNewsStrings>(context, FlutterNewsStrings);
  }

  String get title => Intl.message('Flutter News',
      name: 'title', desc: 'Title for the Flutter News application', locale: _localeName);
}