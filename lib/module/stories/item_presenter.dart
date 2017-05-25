import 'dart:async';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_item.dart';

abstract class ItemViewContract {
  void onLoadItemComplete(HnItem item);
  void onLoadItemError();
}

class ItemPresenter {
  ItemViewContract _view;
  HnItemRepository _repository;

  ItemPresenter(this._view) {
    _repository = new Injector().hnItemRepository;
  }

  Future<Null> loadItem(int itemId, [bool forceReload = false]) async {
    assert(_view != null);

    HnItem item;

    try {
      item = await _repository.load(itemId, forceReload);
      _view.onLoadItemComplete(item);
    } catch (error) {
      print(error);
      _view.onLoadItemError();
    }
  }
}
