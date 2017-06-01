String parseDomain(String url) {
  url = url.replaceFirst(new RegExp(r'https?:\/\/(www.)?|www.'), '');
  if (url.contains('/')) {
    final parts = url.split('/');
    url = parts[0];
  } else if (url.contains('?')) {
    final parts = url.split('?');
    url = parts[0];
  }
  return url;
}

String formatText(String str) {
  return str
      .replaceAll(new RegExp('<p>'), '\n\n')
      .replaceAll(new RegExp('&#x2F;'), '/')
      .replaceAll(new RegExp('<i>'), '')
      .replaceAll(new RegExp('</i>'), '')
      .replaceAll(new RegExp('&#x27;'), '\'')
      .replaceAll(new RegExp('&quot;'), '\"')
      .replaceAll(
      new RegExp(r'<a\s+(?:[^>]*?\s+)?href="([^"]*)" rel="nofollow">'), '')
      .replaceAll(new RegExp('</a>'), '');
}

bool notNull(Object o) => o != null;
