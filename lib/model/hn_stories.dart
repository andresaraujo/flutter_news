import 'dart:async';

enum StoryType { top, newest, best, show, job, ask }

class HnStories {
  final StoryType storyType;
  final List<int> storyList;

  const HnStories({this.storyType, this.storyList});

  HnStories.fromList(this.storyType, this.storyList);
}

abstract class HnStoriesRepository {
  static final _cache = <String, HnStories>{};

  // Abstract method to be defined in implementations
  Future<HnStories> fetch(StoryType storyType);

  Future<HnStories> load(StoryType storyType,
      [bool forceReload = false]) async {
    final storyTypeString = storyType.toString();

    if (_cache.containsKey(storyTypeString) && !forceReload) {
      return _cache[storyTypeString];
    } else {
      final hnStories = await fetch(storyType);
      _cache[storyTypeString] = hnStories;
      return hnStories;
    }
  }
}
