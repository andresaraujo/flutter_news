import 'dart:async';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_item.dart';

abstract class CommentsViewContract {
  void onLoadCommentsComplete(HnItem story);
  void onLoadCommentsError();
}

class CommentsPresenter {
  CommentsViewContract _view;
  HnItemRepository _repository;

  CommentsPresenter(this._view) {
    _repository = new Injector().hnItemRepository;
  }

  Future<Null> loadItem(int itemId) async {
    assert(_view != null);

    try {
      final HnItem item = await _repository.load(itemId);
      _view.onLoadCommentsComplete(item);
    } catch (error) {
      print(error);
      _view.onLoadCommentsError();
    }
  }

  // Temporarily moved from hn_api
  Future<List<HnItem>> getComments(List<int> ids) async {
    final Iterable<Future<HnItem>> comments = ids.take(5).map((int id) {
      return _repository.load(id);
    });
    return Future.wait(comments);
  }

}
