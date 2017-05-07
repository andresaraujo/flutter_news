import 'package:flutter/material.dart';
import 'package:flutter_news/item_model.dart';

class TopItemTile extends StatelessWidget {
  final HnItem story;
  final GestureTapCallback onTap;

  TopItemTile(this.story, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onTap,
      child: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Row(
            children: [
              new Expanded(
                  child: new Container(
                    padding: new EdgeInsets.only(right: 10.0),
                    child: new Column(
                        children: [
                          buildBadge(story.score),
                          buildBadge(story.commentsCount, greyed: true),
                        ]
                    ),
                  )
              ),
              new Expanded(
                flex: 8,
                child: _buildColumn(),
              ),
            ]
        ),
      )
    );
  }

  CircleAvatar buildBadge(int count, {bool greyed: false}) {
    final bgColor = greyed ? Colors.grey : Colors.orange;
    return new CircleAvatar(

        backgroundColor: bgColor,
        child: new Text('$count',
          textAlign: TextAlign.center,
          style: new TextStyle(fontSize: 10.0),
        )
    );
  }

  _buildText(String text, {bold: false}) {
    final fontWeight = bold ? FontWeight.bold : FontWeight.normal;
    return new Container(
        padding: new EdgeInsets.only(bottom: 5.0),
        child: new Text(text,
            style: new TextStyle(
                fontWeight: fontWeight,
              fontSize: 13.0
            )
        )
    );
  }

  _buildColumn() {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildText(story.title, bold: true),
          _buildText(story.url),
          _buildText('by ${story.user} 5 hours ago'),
        ]
    );
  }
}