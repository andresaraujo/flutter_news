import 'dart:async';

import 'package:flutter/foundation.dart';

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

    try {
      final item = await _repository.load(itemId, forceReload);
      _view.onLoadItemComplete(item);
    } catch (e) {
      debugPrint('Exception while loading item:\n  $e');
      _view.onLoadItemError();
    }
  }
}
