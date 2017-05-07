import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';

class TitleSectionTile extends StatelessWidget {

  final HnItem item;

  TitleSectionTile(this.item);

  _buildText(String text, TextStyle style) {
    return new Text(text, style: style);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    final captionStyle = textTheme.caption;

    Widget top = _buildText('${item.title}', textTheme.title);
    Widget middle = new Container();
    Widget bottom = _buildText('Posted by ${item.user}', captionStyle);

    if (item.type == 'comment') {
      top = new Text('${item.text}', style: textTheme.body2);
      middle =
          _buildText('${item.score} Points | ${item.commentsCount} Comments ',
              captionStyle);
    }

    final children = [
      top,
      middle,
      bottom,
    ];

    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: new Column(
        children: children,
      ),
    );
  }
}
