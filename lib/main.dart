import 'package:flutter/material.dart';
import 'package:flutter_news/pages/top_items_page/top_items_page.dart';

void main() {
  runApp(new FlutterNewsApp());
}

class FlutterNewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.orange, brightness: Brightness.light),
      home: new TopItemsPage(),
    );
  }
}
