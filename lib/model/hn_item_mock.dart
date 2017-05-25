import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter_news/model/hn_item.dart';

const JsonCodec jsonCodec = const JsonCodec();

class MockHnItemRepository extends HnItemRepository {
  @override
  Future<HnItem> fetch(int itemId) async {
    final String mockData =
        await rootBundle.loadString('assets/mock_data/$itemId.json');

    final Map<String, dynamic> item = jsonCodec.decode(mockData);

    return new HnItem.fromMap(item);
  }
}
