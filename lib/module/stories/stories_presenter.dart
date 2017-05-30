import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_stories.dart';

abstract class StoriesListViewContract {
  void onLoadStoriesComplete(HnStories items);
  void onLoadStoriesError();
}

class StoriesListPresenter {
  StoriesListViewContract _view;
  HnStoriesRepository _repository;

  StoriesListPresenter(this._view) {
    _repository = new Injector().hnStoriesRepository;
  }

  Future<Null> loadStories(StoryType storyType,
      [bool forceReload = false]) async {
    assert(_view != null);

    try {
      final stories = await _repository.load(storyType, forceReload);
      _view.onLoadStoriesComplete(stories);
    } catch (e) {
      debugPrint('Exception while loading stories:\n  $e');
      _view.onLoadStoriesError();
    }
  }
}
