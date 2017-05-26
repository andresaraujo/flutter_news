import 'dart:async';

enum StoryType { top, newest, best, show, job, ask }

class HnStories {
  final StoryType storyType;
  final List<int> storyList;

  const HnStories({this.storyType, this.storyList});

  HnStories.fromList(StoryType storyType, List<int> list)
      : storyType = storyType,
        storyList = list;
}

abstract class HnStoriesRepository {
  static Map<String, HnStories> _cache = new Map<String, HnStories>();

  // Abstract method to be defined in implementations
  Future<HnStories> fetch(StoryType storyType);

  Future<HnStories> load(StoryType storyType,
      [bool forceReload = false]) async {
    final String storyTypeString = storyType.toString();

    if (_cache.containsKey(storyTypeString) && !forceReload) {
      return _cache[storyTypeString];
    } else {
      final HnStories hnStories = await fetch(storyType);
      _cache[storyTypeString] = hnStories;
      return hnStories;
    }
  }
}
