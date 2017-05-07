import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_news/item_model.dart';

const debugMode = false;

const baseUrl = debugMode ? 'http://localhost:3000' : 'https://hacker-news.firebaseio.com/v0';
const topStoriesUrl = '$baseUrl/topstories.json';
const newStoriesUrl = '$baseUrl/newstories.json';
const showStoriesUrl = '$baseUrl/showstories.json';
const jobStoriesUrl = '$baseUrl/jobstories.json';
const askStoriesUrl = '$baseUrl/askstories.json';
const itemUrl = '$baseUrl/item';

const jsonCodec = const JsonCodec();

Future<List<HnItem>> getTopStories() async {
  final httpClient = createHttpClient();
  final response = await httpClient.get(topStoriesUrl);

  List<int> topStories = jsonCodec.decode(response.body);

  final futures = topStories.take(10).map((s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getNewStories() async {
  final httpClient = createHttpClient();
  final response = await httpClient.get(newStoriesUrl);

  List<int> topStories = jsonCodec.decode(response.body);

  final futures = topStories.take(10).map((s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getShowStories() async {
  final httpClient = createHttpClient();
  final response = await httpClient.get(showStoriesUrl);

  List<int> topStories = jsonCodec.decode(response.body);

  final futures = topStories.take(10).map((s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getAskStories() async {
  final httpClient = createHttpClient();
  final response = await httpClient.get(askStoriesUrl);

  List<int> topStories = jsonCodec.decode(response.body);

  final futures = topStories.take(10).map((s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getJobStories() async {
  final httpClient = createHttpClient();
  final response = await httpClient.get(jobStoriesUrl);

  List<int> topStories = jsonCodec.decode(response.body);

  final futures = topStories.take(10).map((s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getComments(List<int> ids) async {
  final futures = ids.take(5).map((s) => getItem(s));
  return Future.wait(futures);
}

Future<HnItem> getItem(int id) async {
  final httpClient = createHttpClient();

  final url = debugMode ? '$itemUrl/$id' : '$itemUrl/$id.json';
  final response = await httpClient.get(url);

  Map<String, dynamic> story = jsonCodec.decode(response.body);

  return new HnItem.fromJson(story);
}