Intl package: https://pub.dartlang.org/packages/intl

Make sure you have FLUTTER_ROOT evnvironment variable set correctly for following commands to work.

To extract strings into arb files run:

```
pub run intl_translation:extract_to_arb \
  --output-dir=lib/i18n \
  lib/*.dart lib/pages/item_page/*.dart lib/pages/top_items_page/*.dart
```

To rebuild the i18n files:

```
pub run intl_translation:generate_from_arb \
  --output-dir=lib/i18n \
  --generated-file-prefix=fnews_ \
  --no-use-deferred-loading \
  lib/*.dart \
  lib/i18n/*.arb
```
