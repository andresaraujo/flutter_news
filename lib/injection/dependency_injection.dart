import 'package:flutter_news/model/hn_item.dart';
import 'package:flutter_news/model/hn_item_live.dart';
import 'package:flutter_news/model/hn_item_mock.dart';
import 'package:flutter_news/model/hn_story.dart';
import 'package:flutter_news/model/hn_story_live.dart';
import 'package:flutter_news/model/hn_story_mock.dart';

enum Environment { mock, production }

class Injector {
  static final Injector _singleton = new Injector._internal();
  static Environment _environment;

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  static void configure(Environment environment) {
    _environment = environment;
  }

  HnStoryRepository get hnStoryRepository {
    switch (_environment) {
      case (Environment.mock):
        return new MockHnStoryRepository();
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
