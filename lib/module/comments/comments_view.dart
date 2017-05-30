import 'package:flutter_news/module/comments/comments_title_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/module/comments/comment_view.dart';
import 'package:flutter_news/model/hn_item.dart';

class CommentsPage extends StatefulWidget {
  final FlutterNewsConfiguration configuration;
  final HnItem item;

  const CommentsPage(this.item, this.configuration);

  @override
  CommentsPageState createState() => new CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<int> _commentIdList;

  @override
  void initState() {
    super.initState();
    _commentIdList = widget.item.kids;
  }

  @override
  Widget build(BuildContext context) {
    String title;
    final appBarActions = <IconButton>[];

    switch (widget.item.type) {
      case 'story':
        title = widget.item.title;
        if (widget.item.url.isNotEmpty) {
          appBarActions.add(
            new IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: _launchURL,
            ),
          );
        }
        break;
      case 'comment':
        title = 'Comment by ${widget.item.user}';
        break;
    }

    appBarActions.add(new IconButton(
      icon: const Icon(Icons.share),
      onPressed: _share,
    ));

    return new Scaffold(
      key: _scaffoldKey,
      body: new CustomScrollView(slivers: <Widget>[
        new SliverAppBar(
          actions: appBarActions,
          floating: true,
          snap: true,
          title: new Text(title),
        ),
        new SliverToBoxAdapter(
          child: new CommentsTitleTile(widget.item),
        ),
        new SliverPadding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0.0),
          sliver: new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new CommentTile(
                    _commentIdList[index], widget.configuration);
              },
              childCount: _commentIdList.length,
            ),
          ),
        ),
      ]),
    );
  }

  void _launchURL() {
    launch(widget.item.url);
  }

  void _share() {
    _scaffoldKey.currentState
        .showSnackBar(const SnackBar(content: const Text('Not implemented yet!')));
  }
}
