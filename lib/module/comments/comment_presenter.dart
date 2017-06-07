import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_news/fnews_configuration.dart';
import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/module/comments/comments_presenter.dart';

abstract class CommentViewContract {
  void onLoadCommentComplete(HnItem comment);
  void onLoadCommentError();
}

class CommentPresenter {
  CommentsPresenter _parentPresenter;
  CommentViewContract _view;
  HnItemRepository _repository;

  CommentPresenter(this._view, this._parentPresenter) {
    _repository = new Injector().hnItemRepository;
  }

  Future<Null> loadComment(int itemId, FlutterNewsConfiguration config) async {
    assert(_view != null);

    try {
      final item = await _repository.load(itemId);
      if (config.expandCommentTree)
        _parentPresenter.insertComments(item.itemId, item.kids);
      _view.onLoadCommentComplete(item);
    } catch (e) {
      debugPrint('Exception while loading comment:\n  $e');
      _view.onLoadCommentError();
    }
  }
}
