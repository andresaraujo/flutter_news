import 'package:html_unescape/html_unescape.dart';

import 'package:flutter/material.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/module/comments/comment_presenter.dart';
import 'package:flutter_news/module/comments/comments_view.dart';
import 'package:flutter_news/utils.dart';

const int maxLinesDenseComment = 5;
const int maxLinesFullComment = 80;

class CommentTile extends StatefulWidget {
  final FlutterNewsConfiguration configuration;
  final int itemId;

  CommentTile(this.itemId, this.configuration);

  @override
  CommentTileState createState() => new CommentTileState();
}

class CommentTileState extends State<CommentTile>
    implements CommentViewContract {
  HnItem _item;
  CommentPresenter _presenter;
  bool _showFullComment;

  final HtmlUnescape _unescape = new HtmlUnescape();

  @override
  void initState() {
    super.initState();

    _presenter = new CommentPresenter(this);
    _item = new HnItem(
      itemId: 0,
      title: "",
      text: "Loading...",
      type: "comment",
      deleted: false,
      time: 0,
      url: "",
      user: "",
      score: 0,
      commentsCount: 0,
      kids: <int>[],
    );

    _showFullComment = widget.configuration.showFullComment;
    _presenter.loadComment(widget.itemId);
  }

  @override
  void didUpdateWidget(CommentTile tile) {
    _presenter.loadComment(widget.itemId);
    super.didUpdateWidget(tile);
  }

  @override
  void onLoadCommentComplete(HnItem item) {
    if (mounted) {
      setState(() {
        _item = item;
      });
    }
  }

  @override
  void onLoadCommentError() {
    if (mounted) {
      setState(() {
        _item = _item.copyWith(text: "Error loading comment");
      });
    }
  }

  void _onTapItem() {
    if (mounted) {
      setState(() {
        _showFullComment = !_showFullComment;
      });
    }
  }

  Widget _buildReplyButton() {
    if (_item.kids.isEmpty) return null;

    return new ButtonTheme.bar(
      child: new ButtonBar(
        alignment: MainAxisAlignment.end,
        children: <Widget>[
          new FlatButton(
            child: new Text('Show Replies (${_item.kids.length})'),
            onPressed: () {
              _onShowRepliesPressed();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String itemText = _unescape.convert(_item.text);

    return new Card(
      child: new InkWell(
        onTap: _onTapItem,
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Comment user
              new Text(
                _item.user,
                style: textTheme.caption,
              ),
              // Comment text
              (_showFullComment)
                  ? new Text(
                      itemText,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: maxLinesFullComment,
                      style: textTheme.body1,
                    )
                  : new Text(
                      itemText,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: maxLinesDenseComment,
                      style: textTheme.body1,
                    ),
              // Show Reply button
              _buildReplyButton(),
            ].where(notNull).toList(),
          ),
        ),
      ),
    );
  }

  void _onShowRepliesPressed() {
    final MaterialPageRoute<Null> page = new MaterialPageRoute<Null>(
      settings: new RouteSettings(name: '${_item.itemId}'),
      builder: (_) => new CommentsPage(_item, widget.configuration),
    );
    Navigator.of(context).push(page);
  }
}
