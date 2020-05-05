import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/model/story.dart';

class EditStoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditStoryState();
  }
}

class _EditStoryState extends State<EditStoryPage> {
  String _title;
  String _content;
  // ignore: use_setters_to_change_properties
  void _setTitle(String title) => _title = title;
  void _setContent(String content) => _content = content;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              onChanged: _setTitle,
            ),
            TextField(
              onChanged: _setContent,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    var story = Story(
      title: _title,
      content: _content,
      createTime: DateTime.now().toIso8601String(),
      updateTime: DateTime.now().toIso8601String(),
    );

    SqlProvider().insertStory(story);
    super.dispose();
  }
}
