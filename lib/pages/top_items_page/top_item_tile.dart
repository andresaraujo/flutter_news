import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/utils.dart';

class TopItemTile extends StatelessWidget {
  final HnItem story;
  final GestureTapCallback onTap;

  TopItemTile(this.story, {this.onTap});

  _buildBadge(int count, Color backgroundColor, TextTheme textTheme) {
    TextStyle textStyle = textTheme.caption.copyWith(
        color: Colors.white, fontSize: 10.0);
    return new Container(
        margin: const EdgeInsets.only(bottom: 2.0),
        width: 25.0,
        height: 25.0,
        decoration: new BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: new Container(
            padding: new EdgeInsets.all(2.0),
            child: new Center(child: new Text('$count', style: textStyle))
        )
    );
  }

  _buildText(String text, TextTheme textTheme) {
    return new Container(
        padding: new EdgeInsets.only(bottom: 5.0),
        child: new Text(text,
          style: textTheme.caption,
        )
    );
  }

  _buildTop(TextTheme textTheme) {
    final children = [];

    if (story.url.isNotEmpty) {
      children.add(new TextSpan(
        text: '(${parseDomain(story.url)})',
        style: textTheme.caption,
      ));
    }

    return new RichText(
      text: new TextSpan(
        text: '${story.title} ',
        style: textTheme.body2,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme
        .of(context);

    final textTheme = theme.textTheme;

    final badgeChildren = [
      _buildBadge(story.score, theme.primaryColor, textTheme),
      _buildBadge(story.commentsCount, theme.disabledColor, textTheme),
    ];

    final itemColumn = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTop(textTheme),
          _buildText('by ${story.user} | ${story.timeAgo}', textTheme),
        ]
    );

    return new InkWell(
        onTap: onTap,
        child: new Container(
          padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: new Row(
              children: [
                new Expanded(
                    child: new Container(
                      padding: new EdgeInsets.only(right: 10.0),
                      child: new Column(
                          children: badgeChildren
                      ),
                    )
                ),
                new Expanded(
                  flex: 6,
                  child: itemColumn,
                ),
              ]
          ),
        )
    );
  }
}