import 'dart:async';

enum StoryType {top, newest, best, show, job, ask}

class HnStories {
  final List<int> storyList;

  const HnStories({this.storyList});

  HnStories.fromList(List<int> list)
      : storyList = list;
}

abstract class HnStoriesRepository {
  Future<HnStories> fetch(StoryType storyType);
}
