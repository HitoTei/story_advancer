import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/model/story.dart';

class EditStoryPage extends StatefulWidget {
  const EditStoryPage({Story story}) : _story = story;
  final Story _story;

  @override
  State<StatefulWidget> createState() {
    return _EditStoryState(_story);
  }
}

class _EditStoryState extends State<EditStoryPage> {
  _EditStoryState(Story story) : _story = story ?? Story();

  final Story _story;
  void _setTitle(String title) => _story.title = title;
  void _setContent(String content) => _story.content = content;
  void _setLocation(String location) => _story.location = location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            TextField(
              onChanged: _setTitle,
            ),
            TextField(
              onChanged: _setContent,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            TextField(
              onChanged: _setLocation,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    save();
    super.dispose();
  }

  Future<void> save() async {
    _story.updateTime = DateTime.now().toIso8601String();
    _story.createTime ??= DateTime.now().toIso8601String();

    await SqlProvider().insertStory(_story);
  }
}
