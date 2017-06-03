import 'package:flutter_news/module/comments/comments_presenter.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:flutter/material.dart';

import 'package:flutter_news/utils.dart';
import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/module/comments/comment_presenter.dart';
import 'package:flutter_news/module/comments/comments_view.dart';

const int maxLinesDenseComment = 5;
const int maxLinesFullComment = 80;

class CommentTile extends StatefulWidget {
  final FlutterNewsConfiguration configuration;
  final int itemId;
  final CommentsPresenter parentPresenter;

  CommentTile(this.itemId, this.configuration, this.parentPresenter);

  @override
  CommentTileState createState() => new CommentTileState();
}

class CommentTileState extends State<CommentTile>
    implements CommentViewContract {
  HnItem _item;
  CommentPresenter _presenter;
  bool _showFullComment;
  bool _expandCommentTree;

  final _unescape = new HtmlUnescape();

  @override
  void initState() {
    super.initState();

    _presenter = new CommentPresenter(this, widget.parentPresenter);
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
      isCached: false,
      depthLevel: 0,
    );

    _showFullComment = widget.configuration.showFullComment;
    _expandCommentTree = widget.configuration.expandCommentTree;

    // Start loading comment
    _presenter.loadComment(widget.itemId);
  }

  @override
  void didUpdateWidget(CommentTile tile) {
    // Start loading comment
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
        _item.text = "Error loading comment id: ${widget.itemId}";
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
    final textTheme = Theme.of(context).textTheme;

    final defaultStyle = DefaultTextStyle.of(context).style;
    final italicStyle = defaultStyle.copyWith(fontStyle: FontStyle.italic);

    final itemText = _unescape.convert(_item.text);
    final textLines = itemText.split('\n');

    final depthLevel = (_item.depthLevel < 5) ? _item.depthLevel : 5;

    final textSpanList = <TextSpan>[];
    for (var line in textLines) {
      if (line.isEmpty) line = "\n\n";
      textSpanList.add(new TextSpan(
        text: line,
        style: (line[0] == '>') ? italicStyle : defaultStyle,
      ));
    }

    return new Padding(
      padding: new EdgeInsets.only(left: 8.0 * depthLevel),
      child: new Card(
        child: new InkWell(
          onTap: _onTapItem,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Comment user
                new Text(
                  //_item.user,
                  '${_item.user} (${_item.itemId} / $depthLevel)',
                  style: textTheme.caption,
                ),
                // Comment text
                new RichText(
                  text: new TextSpan(
                    style: defaultStyle,
                    children: textSpanList,
                  ),
                  maxLines: (_showFullComment)
                      ? maxLinesFullComment
                      : maxLinesDenseComment,
                ),
                // Show Reply button
                (_expandCommentTree) ? null: _buildReplyButton(),
              ].where(notNull).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _onShowRepliesPressed() {
    final page = new MaterialPageRoute<Null>(
      settings: new RouteSettings(name: '${_item.itemId}'),
      builder: (_) => new CommentsPage(_item, widget.configuration),
    );
    Navigator.of(context).push(page);
  }
}
