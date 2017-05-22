import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/utils.dart';

class TopItemTile extends StatelessWidget {
  final HnItem story;
  final GestureTapCallback onTap;

  TopItemTile(this.story, {this.onTap});

  Widget _buildBadge(int count, Color backgroundColor, TextTheme textTheme) {
    final TextStyle textStyle =
        textTheme.caption.copyWith(color: Colors.white, fontSize: 10.0);
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
            child: new Center(child: new Text('$count', style: textStyle))));
  }

  Widget _buildText(String text, TextTheme textTheme) {
    return new Container(
        padding: new EdgeInsets.only(bottom: 5.0),
        child: new Text(
          text,
          style: textTheme.caption,
        ));
  }

  Widget _buildTop(TextTheme textTheme) {
    final List<TextSpan> children = <TextSpan>[];

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
    final ThemeData theme = Theme.of(context);

    final TextTheme textTheme = theme.textTheme;

    final List<Widget> badgeChildren = <Widget>[
      _buildBadge(story.score, Colors.orange, textTheme),
      _buildBadge(story.commentsCount, theme.disabledColor, textTheme),
    ];

    final Widget itemColumn = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTop(textTheme),
          _buildText('by ${story.user} | ${story.timeAgo}', textTheme),
        ]);

    return new InkWell(
        onTap: onTap,
        child: new Container(
          padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: new Row(children: <Widget>[
            new Expanded(
                child: new Container(
              padding: new EdgeInsets.only(right: 10.0),
              child: new Column(children: badgeChildren),
            )),
            new Expanded(
              flex: 6,
              child: itemColumn,
            ),
          ]),
        ));
  }
}
