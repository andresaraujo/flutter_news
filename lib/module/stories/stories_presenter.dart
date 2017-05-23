import 'dart:async';

import 'package:flutter_news/injection/dependency_injection.dart';
import 'package:flutter_news/model/hn_story.dart';

abstract class StoriesListViewContract {
  void onLoadStoriesComplete(List<HnStory> items);
  void onLoadStoriesError();
}

class StoriesListPresenter {
  StoriesListViewContract _view;
  HnStoryRepository _repository;

  static final Map<String, List<HnStory>> _cache = <String, List<HnStory>>{};

  StoriesListPresenter(this._view) {
    _repository = new Injector().hnStoryRepository;
  }

  Future<Null> loadStories(StoryType storyType) async {
    assert(_view != null);

    List<HnStory> stories;
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
