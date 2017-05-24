import 'dart:async';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_stories.dart';

abstract class StoriesListViewContract {
  void onLoadStoriesComplete(HnStories items);
  void onLoadStoriesError();
}

class StoriesListPresenter {
  StoriesListViewContract _view;
  HnStoriesRepository _repository;

  static final Map<String, HnStories> _cache = <String, HnStories>{};

  StoriesListPresenter(this._view) {
    _repository = new Injector().hnStoriesRepository;
  }

  Future<Null> loadStories(StoryType storyType) async {
    assert(_view != null);

    HnStories stories;
    final String _storyTypeString = storyType.toString();

    try {
      if (_cache.containsKey(_storyTypeString)) {
        stories = _cache[_storyTypeString];
      } else {
        stories = await _repository.fetch(storyType);
        _cache[_storyTypeString] = stories;
      }
      _view.onLoadStoriesComplete(stories);
    } catch (error) {
      print(error);
      _view.onLoadStoriesError();
    }
  }
}
