import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_item.dart';

abstract class CommentViewContract {
  void onLoadCommentComplete(HnItem comment);
  void onLoadCommentError();
}

class CommentPresenter {
  CommentViewContract _view;
  HnItemRepository _repository;

  CommentPresenter(this._view) {
    _repository = new Injector().hnItemRepository;
  }

  Future<Null> loadComment(int itemId) async {
    assert(_view != null);

    try {
      final HnItem item = await _repository.load(itemId);
      _view.onLoadCommentComplete(item);
    } catch (e) {
      debugPrint('Exception while loading comment:\n  $e');
      _view.onLoadCommentError();
    }
  }

}
