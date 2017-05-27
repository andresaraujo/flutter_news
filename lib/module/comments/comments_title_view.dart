import 'package:flutter/material.dart';

import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/utils.dart';

class CommentsTitleTile extends StatelessWidget {
  final HnItem item;

  CommentsTitleTile(this.item);

  Widget _buildTop(String title, String url, TextTheme textTheme) {
    final List<TextSpan> children = <TextSpan>[];

    if (url.isNotEmpty) {
      children.add(new TextSpan(
        text: '(${parseDomain(url)})',
        style: textTheme.caption,
      ));
    }
    return new Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: new RichText(
        text: new TextSpan(
          text: '$title ',
          style: textTheme.title,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget topWidget;
    Widget bottomWidget;

    if (item.type == 'story') {
      topWidget = _buildTop(item.title, item.url, textTheme);
      bottomWidget = new Text(
        '${item.score} Points | by ${item.user}',
        style: textTheme.caption,
      );
    } else {
      topWidget = new Text(
        '${item.text}',
        style: textTheme.body2,
      );
      bottomWidget = new Container();
    }

    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          topWidget,
          bottomWidget,
        ],
      ),
    );
  }
}
