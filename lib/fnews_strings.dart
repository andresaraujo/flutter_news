import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

// Wrappers for strings that are shown in the UI.  The strings can be
// translated for different locales using the Dart intl package.
//
// Locale-specific values for the strings live in the i18n/*.arb files.
//
// To generate the stock_messages_*.dart files from the ARB files, run:
//   pub run intl_translation:generate_from_arb --output-dir=lib/i18n --generated-file-prefix=fnews_ --no-use-deferred-loading lib/fnews_strings.dart lib/i18n/fnews_*.arb

class FlutterNewsStrings extends LocaleQueryData {
  static FlutterNewsStrings of(BuildContext context) {
    return LocaleQuery.of(context);
  }

  static final FlutterNewsStrings instance = new FlutterNewsStrings();

  String title() => Intl.message('Flutter Nexs',
      name: 'title', desc: 'Title for the Flutter News application');
}
