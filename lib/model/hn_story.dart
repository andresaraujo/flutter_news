import 'dart:async';

enum StoryType {top, newest, best, show, job, ask}

class HnStory {
  final int storyId;

  const HnStory({this.storyId = 0});
}

abstract class HnStoryRepository {
  Future<List<HnStory>> fetch(StoryType storyType);
}

