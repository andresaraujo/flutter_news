import 'package:flutter/material.dart';
import 'package:flutter_news/hn_api.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/pages/item_page/item_page.dart';
import 'package:flutter_news/utils.dart';

class TopItemTile extends StatefulWidget {
  final int storyId;

  TopItemTile(this.storyId);

  @override
  TopItemTileState createState() => new TopItemTileState();
}

class TopItemTileState extends State<TopItemTile> {
  HnItem _story = new HnItem();

  @override
  void initState() {
    super.initState();

    // Load story contents
    getHnItem(widget.storyId).then((HnItem hnItem) {
      if (mounted) {
        setState(() {
          _story = hnItem;
        });
      }
    });
  }

  void _onTapItem(HnItem story) {
    final MaterialPageRoute<Null> page = new MaterialPageRoute<Null>(
      settings: new RouteSettings(name: '${story.title}'),
      builder: (_) => new ItemPage(story),
    );
    Navigator.of(context).push(page);
  }

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
            child: new Center(
                child: new Text(count.toString(), style: textStyle))));
  }

  Widget _buildText(String text, TextTheme textTheme) {
    return new Container(
        padding: new EdgeInsets.only(bottom: 5.0),
        child: new Text(
          text.length > 0 ? text : "",
          style: textTheme.caption,
        ));
  }

  Widget _buildTop(TextTheme textTheme) {
    final List<TextSpan> children = <TextSpan>[];

    if (_story.url.isNotEmpty) {
      children.add(new TextSpan(
        text: '(${parseDomain(_story.url)})',
        style: textTheme.caption,
      ));
    }

    return new RichText(
      text: new TextSpan(
        text: _story.title.length > 0 ? '${_story.title} ' : "Loading...",
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
      _buildBadge(_story.score, Colors.orange, textTheme),
      _buildBadge(_story.commentsCount, theme.disabledColor, textTheme),
    ];

    final Widget itemColumn = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTop(textTheme),
          _story.user.length > 0
              ? _buildText('by ${_story.user} | ${_story.timeAgo}', textTheme)
              : _buildText('id ' + widget.storyId.toString(), textTheme),
        ]);

    return new InkWell(
        onTap: () => _onTapItem(_story),
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
