import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/hn_api.dart';

bool notNull(Object o) => o != null;

class StoryPage extends StatefulWidget {
  final int index;
  final Item story;

  StoryPage(this.index, this.story);

  @override
  _StoryPageState createState() => new _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();
  List<Item> _comments = [];

  initState() {
    super.initState();
    getComments(widget.story.kids).then((items) {
      setState(() {
        _comments = items;
      });
    });
  }

  buildReplyButton(int commentCount) {
    if (commentCount == 0) return null;

    return new ButtonTheme.bar(child: new ButtonBar(
        alignment: MainAxisAlignment.end,
        children: <Widget>[
          new FlatButton(
            child: new Text('Show Replies ($commentCount)'),
            onPressed: _onShowRepliesPressed,
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    final titleSection = new Container(
      height: 110.0,
      padding: new EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
      child: new Column(
          children: [
            new Expanded(
              child: new Text('${widget.story.title}',
                  style: textTheme.title),
            ),
            new Text(
                'Posted by ${widget.story.user} | ${widget.story.score} Points',
                style: textTheme.caption),
            new Text('${widget.story.commentsCount} Comments:',
                style: textTheme.caption),
          ]
      ),
    );

    final commentCards = _comments.map((Item item) {
      return new Container(
          padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: new Card(
              child: new Padding(
                  padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(item.user, style: textTheme.caption),
                      new Text(item.text,
                        softWrap: true,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.body1,
                      ),
                      buildReplyButton(item.kids.length),
                    ].where(notNull).toList(),
                  )
              )
          )
      );
    });

    final listItems = <Widget>[
      titleSection,
      new Divider()
    ];

    listItems.addAll(commentCards);

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(title: new Text('Top story #${widget.index + 1}')),
        body: new ListView(
          children: listItems,
        )
    );
  }

  void _onShowRepliesPressed() {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text('Not implemented yet!')));
  }
}

