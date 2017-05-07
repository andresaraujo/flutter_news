import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';

class TitleSectionTile extends StatelessWidget {

  final HnItem item;

  TitleSectionTile(this.item);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    Text top = new Text('${item.title}', style: textTheme.title);

    if (item.type == 'comment') {
      top = new Text('${item.text}', style: textTheme.body2);
    }

    final children = [
      top,
      new Text('Posted by ${item.user} | ${item.score} Points',
          style: textTheme.caption),
      new Text('${item.commentsCount} Comments:',
          style: textTheme.caption),
    ];

    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: new Column(
        children: children,
      ),
    );
  }
}
