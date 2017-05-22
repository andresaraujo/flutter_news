// Implementation of Hacker News API
// https://github.com/HackerNews/API

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_news/item_model.dart';
import 'package:http/http.dart';

const bool debugMode = false;

const String baseUrl = debugMode
    ? 'http://localhost:3000'
    : 'https://hacker-news.firebaseio.com/v0';
const String topStoriesUrl = '$baseUrl/topstories.json';
const String newStoriesUrl = '$baseUrl/newstories.json';
const String showStoriesUrl = '$baseUrl/showstories.json';
const String jobStoriesUrl = '$baseUrl/jobstories.json';
const String askStoriesUrl = '$baseUrl/askstories.json';
const String itemUrl = '$baseUrl/item';

const JsonCodec jsonCodec = const JsonCodec();

Future<List<HnItem>> getTopStories() async {
  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(topStoriesUrl);

  final List<int> topStories = jsonCodec.decode(response.body);

  final Iterable<Future<HnItem>> futures =
      topStories.take(10).map((int s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getNewStories() async {
  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(newStoriesUrl);

  final List<int> topStories = jsonCodec.decode(response.body);

  final Iterable<Future<HnItem>> futures =
      topStories.take(10).map((int s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getShowStories() async {
  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(showStoriesUrl);

  final List<int> topStories = jsonCodec.decode(response.body);

  final Iterable<Future<HnItem>> futures =
      topStories.take(10).map((int s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getAskStories() async {
  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(askStoriesUrl);

  final List<int> topStories = jsonCodec.decode(response.body);

  final Iterable<Future<HnItem>> futures =
      topStories.take(10).map((int s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getJobStories() async {
  final Client httpClient = createHttpClient();
  final Response response = await httpClient.get(jobStoriesUrl);

  final List<int> topStories = jsonCodec.decode(response.body);

  final Iterable<Future<HnItem>> futures =
      topStories.take(10).map((int s) => getItem(s));
  return Future.wait(futures);
}

Future<List<HnItem>> getComments(List<int> ids) async {
  final Iterable<Future<HnItem>> futures =
      ids.take(5).map((int s) => getItem(s));
  return Future.wait(futures);
}

Future<HnItem> getItem(int id) async {
  final Client httpClient = createHttpClient();

  final String url = debugMode ? '$itemUrl/$id' : '$itemUrl/$id.json';
  final Response response = await httpClient.get(url);

  final Map<String, dynamic> story = jsonCodec.decode(response.body);

  return new HnItem.fromJson(story);
}
