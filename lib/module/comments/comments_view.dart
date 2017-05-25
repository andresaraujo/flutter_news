import 'package:flutter_news/module/comments/comments_presenter.dart';
import 'package:flutter_news/module/comments/comments_title_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/utils.dart';

class CommentsPage extends StatefulWidget {
  final HnItem item;

  CommentsPage(this.item);

  @override
  CommentsPageState createState() => new CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> implements CommentsViewContract{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  CommentsPresenter _presenter;
  List<HnItem> _comments;

  CommentsPageState() {
    _presenter = new CommentsPresenter(this);
    _comments = <HnItem>[];
  }

  @override
  void initState() {
    super.initState();
    _presenter.getComments(widget.item.kids).then((List<HnItem> items) {
      setState(() {
        _comments = items;
      });
    });
  }

  @override
  void onLoadCommentsComplete(HnItem story) {
    /*
    if (mounted) {
      setState(() {
      });
    }
    */
  }

  @override
  void onLoadCommentsError() {
    // TODO: implement onLoadStoriesError
  }



  Widget _buildReplyButton(HnItem item) {
    if (item.kids.length == 0) return null;

    return new ButtonTheme.bar(
        child:
            new ButtonBar(alignment: MainAxisAlignment.end, children: <Widget>[
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Iterable<Container> commentCards =
        _comments.where((HnItem i) => !i.deleted).map((HnItem item) {
      return new Container(
          padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: new Card(
              child: new Padding(
                  padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(item.user, style: textTheme.caption),
                      new Text(
                        item.text,
                        softWrap: true,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.body1,
                      ),
                      _buildReplyButton(item),
                    ].where(notNull).toList(),
                  ))));
    });

    final List<Widget> listItems = <Widget>[
      new CommentsTitleTile(widget.item),
      new Divider()
    ];

    listItems.addAll(commentCards);

    String title = '';
    final List<IconButton> actions = <IconButton>[];

    switch (widget.item.type) {
      case 'story':
        title = '';
        if (widget.item.url.isNotEmpty) {
          actions.add(
            new IconButton(
                icon: const Icon(Icons.open_in_browser), onPressed: _launchURL),
          );
        }
        break;
      case 'comment':
        title = 'Comment by ${widget.item.user}';
        break;
    }

    actions
        .add(new IconButton(icon: const Icon(Icons.share), onPressed: _share));

    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(title),
          actions: actions,
        ),
        body: new ListView(
          children: listItems,
        ));
  }

  void _onShowRepliesPressed(HnItem item) {
    final MaterialPageRoute<Null> page = new MaterialPageRoute<Null>(
      settings: new RouteSettings(name: '${item.title}'),
      builder: (_) => new CommentsPage(item),
    );
    Navigator.of(context).push(page);
  }

  void _launchURL() {
    launch(widget.item.url);
  }

  void _share() {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('Not implemented yet!')));
  }
}
