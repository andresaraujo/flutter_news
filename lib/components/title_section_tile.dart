import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/utils.dart';

class TitleSectionTile extends StatelessWidget {

  final HnItem item;

  TitleSectionTile(this.item);

  _buildText(String text, TextStyle style) {
    return new Text(text, style: style);
  }

  _buildTop(String title, String url, TextTheme textTheme) {
    return new Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: new RichText(text: new TextSpan(
          text: '$title ',
          style: textTheme.title,
          children: [
            new TextSpan(
                text: '(${parseDomain(url)})', style: textTheme.caption)
          ],
        ))
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    final captionStyle = textTheme.caption;

    Widget top = _buildTop(item.title, item.url, textTheme);
    Widget bottom = _buildText('${item.score} Points | by ${item.user}',
        captionStyle);

    if (item.type == 'comment') {
      top = new Text('${item.text}', style: textTheme.body2);
      bottom = new Container();
    }

    final children = [
      top,
      bottom,
    ];

    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
