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

  static final Map<int, HnItem> _cache = <int, HnItem>{};

  ItemPresenter(this._view) {
    _repository = new Injector().hnItemRepository;
  }

  Future<Null> loadItem(int itemId) async {
    assert(_view != null);

    HnItem item;

    try {
      if (_cache.containsKey(itemId)) {
        item = _cache[itemId];
        print("from cache $itemId");
      } else {
        print("loading $itemId");
        item = await _repository.fetch(itemId);
        _cache[itemId] = item;
      }
      _view.onLoadItemComplete(item);
    } catch (error) {
      print(error);
      _view.onLoadItemError();
    }
  }
}
