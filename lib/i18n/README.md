Intl package: https://pub.dartlang.org/packages/intl

Make sure you have FLUTTER_ROOT evnvironment variable set correctly for following commands to work.

To rebuild the i18n files:

```
pub run intl_translation:generate_from_arb \
  --output-dir=lib/i18n \
  --generated-file-prefix=fnews_ \
  --no-use-deferred-loading \
  lib/fnews_strings.dart \
  lib/i18n/fnews_en.arb lib/i18n/fnews_es.arb
```

You might want to exclude generated message files from analyzing.  
See: https://github.com/dart-lang/intl_translation/issues/9
