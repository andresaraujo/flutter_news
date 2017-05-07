import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_news/pages/item_page/title_section_tile.dart';
import 'package:flutter_news/item_model.dart';
import 'package:flutter_news/hn_api.dart';

bool notNull(Object o) => o != null;

class ItemPage extends StatefulWidget {
  final int index;
  final HnItem item;

  ItemPage(this.item, {this.index});

  @override
  _StoryPageState createState() => new _StoryPageState();
}

class _StoryPageState extends State<ItemPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();
  List<HnItem> _comments = [];

  initState() {
    super.initState();
    getComments(widget.item.kids).then((items) {
      setState(() {
        _comments = items;
      });
    });
  }

  buildReplyButton(HnItem item) {
    if (item.kids.length == 0) return null;

    return new ButtonTheme.bar(child: new ButtonBar(
        alignment: MainAxisAlignment.end,
        children: <Widget>[
          new FlatButton(
            child: new Text('Show Replies (${item.kids.length})'),
            onPressed: () {
              _onShowRepliesPressed(item);
            },
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    final commentCards = _comments.where((i) => !i.deleted).map((HnItem item) {
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
                      buildReplyButton(item),
                    ].where(notNull).toList(),
                  )
              )
          )
      );
    });

    final listItems = <Widget>[
      new TitleSectionTile(widget.item),
      new Divider()
    ];

    listItems.addAll(commentCards);

    String title = '';
    List<IconButton> actions;

    switch (widget.item.type) {
      case 'story':
        title = 'Top story #${widget.index + 1}';
        actions = [
          new IconButton(
              icon: const Icon(Icons.open_in_browser), onPressed: _launchURL),
        ];
        break;
      case 'comment':
        title = 'Comment by ${widget.item.user}';
        break;
    }

    return new Scaffold(
      //key: _scaffoldKey,
        appBar: new AppBar(
            title: new Text(title),
            actions: actions,
        ),

        body: new ListView(
          children: listItems,
        )
    );
  }

  void _onShowRepliesPressed(HnItem item) {
    /*_scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text('Not implemented yet!')));*/
    final page = new MaterialPageRoute(
        settings: new RouteSettings(name: '${item.title}'),
        builder: (_) => new ItemPage(item)
    );
    Navigator.of(context).push(page);
  }

  _launchURL() {
    launch(widget.item.url);
  }
}
