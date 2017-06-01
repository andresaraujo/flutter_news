import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/model/hn_item_live.dart';
import 'package:flutter_news/model/hn_item_mock.dart';
import 'package:flutter_news/model/hn_stories.dart';
import 'package:flutter_news/model/hn_stories_live.dart';
import 'package:flutter_news/model/hn_stories_mock.dart';

enum Environment { mock, production }

class Injector {
  static final _singleton = new Injector._internal();
  static Environment _environment;

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  static void configure(Environment environment) {
    _environment = environment;
  }

  HnStoriesRepository get hnStoriesRepository {
    switch (_environment) {
      case (Environment.mock):
        return new MockHnStoriesRepository();
      case (Environment.production):
      default:
        return new LiveHnStoryRepository();
    }
  }

  HnItemRepository get hnItemRepository {
    switch (_environment) {
      case (Environment.mock):
        return new MockHnItemRepository();
      case (Environment.production):
      default:
        return new LiveHnItemRepository();
    }
  }

}
