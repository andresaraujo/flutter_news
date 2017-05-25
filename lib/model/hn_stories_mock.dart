import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter_news/model/hn_stories.dart';

const JsonCodec jsonCodec = const JsonCodec();

class MockHnStoriesRepository extends HnStoriesRepository {
  @override
  Future<HnStories> fetch(StoryType storyType) async {
    String _mockFileName;

    switch (storyType) {
      case (StoryType.newest):
        _mockFileName = "newstories";
        break;
      case (StoryType.best):
        _mockFileName = "beststories";
        break;
      case (StoryType.show):
        _mockFileName = "showstories";
        break;
      case (StoryType.job):
        _mockFileName = "jobstories";
        break;
      case (StoryType.ask):
        _mockFileName = "askstories";
        break;
      case (StoryType.top):
      default:
        _mockFileName = "topstories";
        break;
    }

    final String mockData =
        await rootBundle.loadString('assets/mock_data/$_mockFileName.json');

    final List<int> storiesList = jsonCodec.decode(mockData);

    return new HnStories.fromList(storyType, storiesList);
  }
}
