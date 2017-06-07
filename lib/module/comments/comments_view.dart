import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/module/comments/comment_view.dart';
import 'package:flutter_news/module/comments/comments_presenter.dart';
import 'package:flutter_news/module/comments/comments_title_view.dart';

class CommentsPage extends StatefulWidget {
  final FlutterNewsConfiguration configuration;
  final HnItem item;

  const CommentsPage(this.item, this.configuration);

  @override
  CommentsPageState createState() => new CommentsPageState();
}

class CommentsPageState extends State<CommentsPage>
    implements CommentsViewContract {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  CommentsPresenter _presenter;
  List<int> _commentIdList;

  @override
  void initState() {
    super.initState();
    _presenter = new CommentsPresenter(this);
    _presenter.initList(widget.item.kids);
    _commentIdList = widget.item.kids;
  }

  @override
  void onCommentListUpdate() {
    if (mounted) {
      setState(() {
        _commentIdList = _presenter.commentIdList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title;
    final appBarActions = <IconButton>[];

    final HnItem _item = widget.item;

    switch (_item.type) {
      case 'story':
        title = _item.title;
        if (_item.url.isNotEmpty) {
          appBarActions.add(
            new IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: _launchURL,
            ),
          );
        }
        break;
      case 'comment':
        title = 'Comment by ${_item.user}';
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
          child: new CommentsTitleTile(_item),
        ),
        new SliverPadding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          sliver: new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new CommentTile(
                    _commentIdList[index], widget.configuration, _presenter);
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
    _scaffoldKey.currentState.showSnackBar(
        const SnackBar(content: const Text('Not implemented yet!')));
  }
}
