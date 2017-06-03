import 'dart:async';

import 'package:flutter/foundation.dart';

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

  Future<Null> loadComment(int itemId) async {
    assert(_view != null);

    try {
      final item = await _repository.load(itemId);

      // If item is not cached it means it was loaded for the first
      // time and we can add its kids to comment tree
      if(!item.isCached) {
        print("inserting for $itemId");
        _parentPresenter.insertComments(item.itemId, item.kids);
      }
      _view.onLoadCommentComplete(item);
    } catch (e) {
      debugPrint('Exception while loading comment:\n  $e');
      _view.onLoadCommentError();
    }
  }
}
