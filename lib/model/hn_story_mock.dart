import 'dart:async';

import 'package:flutter_news/model/hn_story.dart';

class MockHnStoryRepository implements HnStoryRepository {
  @override
  Future<List<HnStory>> fetch(StoryType storyType) async {
    switch (storyType) {
      case (StoryType.newest):
        return new Future<List<HnStory>>.sync(() {
          return kHnStoriesNewest;
        });
      case (StoryType.best):
        return new Future<List<HnStory>>.sync(() {
          return kHnStoriesBest;
        });
      case (StoryType.show):
        return new Future<List<HnStory>>.sync(() {
          return kHnStoriesShow;
        });
      case (StoryType.job):
        return new Future<List<HnStory>>.sync(() {
          return kHnStoriesJob;
        });
      case (StoryType.ask):
        return new Future<List<HnStory>>.sync(() {
          return kHnStoriesAsk;
        });
      case (StoryType.top):
      default:
        return new Future<List<HnStory>>.sync(() {
          return kHnStoriesTop;
        });
    }
  }
}

const List<HnStory> kHnStoriesNewest = const <HnStory>[
  const HnStory(storyId: 10),
  const HnStory(storyId: 12),
];

const List<HnStory> kHnStoriesBest = const <HnStory>[
  const HnStory(storyId: 10),
  const HnStory(storyId: 12),
];

const List<HnStory> kHnStoriesShow = const <HnStory>[
  const HnStory(storyId: 10),
  const HnStory(storyId: 12),
];

const List<HnStory> kHnStoriesJob = const <HnStory>[
  const HnStory(storyId: 10),
  const HnStory(storyId: 12),
];

const List<HnStory> kHnStoriesAsk = const <HnStory>[
  const HnStory(storyId: 10),
  const HnStory(storyId: 12),
];

const List<HnStory> kHnStoriesTop = const <HnStory>[
  const HnStory(storyId: 14398175),
  const HnStory(storyId: 14397839),
  const HnStory(storyId: 14399355),
  const HnStory(storyId: 14398735),
  const HnStory(storyId: 14398066),
  const HnStory(storyId: 14391993),
  const HnStory(storyId: 14397873),
  const HnStory(storyId: 14392454),
  const HnStory(storyId: 14398868),
  const HnStory(storyId: 14394150),
  const HnStory(storyId: 14391970),
  const HnStory(storyId: 14391955),
  const HnStory(storyId: 14392456),
  const HnStory(storyId: 14393017),
  const HnStory(storyId: 14391458),
  const HnStory(storyId: 14394465),
  const HnStory(storyId: 14396075),
  const HnStory(storyId: 14392659),
  const HnStory(storyId: 14395411),
  const HnStory(storyId: 14393501),
];
