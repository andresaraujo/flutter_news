import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_news/item_model.dart';

const debugMode = false;

const hnUrl = debugMode ? 'http://localhost:3000' : 'https://hacker-news.firebaseio.com/v0';
const hnTopStoriesUrl = '$hnUrl/topstories.json';
const hnItemUrl = '$hnUrl/item';

const jsonCodec = const JsonCodec();

Future<List<Item>> getTopStories() async {
  final httpClient = createHttpClient();
  final response = await httpClient.get(hnTopStoriesUrl);

  List<int> topStories = jsonCodec.decode(response.body);

  final futures = topStories.take(10).map((s) => getStory(s));

  return Future.wait(futures);
}

Future<List<Item>> getComments(List<int> ids) async {

  final futures = ids.take(5).map((s) => getStory(s));

  return Future.wait(futures);
}

Future<Item> getStory(int id) async {
  final httpClient = createHttpClient();

  var url = debugMode ? '$hnItemUrl/$id' : '$hnItemUrl/$id.json';
  final response = await httpClient.get(url);

  Map<String, dynamic> story = jsonCodec.decode(response.body);

  return new Item.fromJson(story);
}