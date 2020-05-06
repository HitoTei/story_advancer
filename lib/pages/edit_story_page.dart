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
  _EditStoryState(Story story) : _story = story ?? Story() {
    List<int> numList = [];
    for (final str in story.ageOfStory.split('-')) numList.add(int.parse(str));
    _year = numList[0];
    _month = numList[1];
    _day = numList[2];
  }

  final Story _story;
  int _year = 0;
  int _month = 0;
  int _day = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            const Text('タイトル'),
            TextField(
              onChanged: (val) => _story.title = val,
            ),
            const Text('本文'),
            TextField(
              onChanged: (val) => _story.content = val,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const Text('場所'),
            TextField(
              onChanged: (val) => _story.location = val,
            ),
            _ageOfStoryWidget(),
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

  Widget _ageOfStoryWidget() {
    return Row(
      children: <Widget>[
        const Text('年'),
        TextField(
          onChanged: (val) => _year = int.parse(val) ?? 0,
          keyboardType: const TextInputType.numberWithOptions(),
        ),
        const Text('月'),
        TextField(
          onChanged: (val) => _month = int.parse(val) ?? 0,
          maxLength: 2,
          keyboardType: const TextInputType.numberWithOptions(),
        ),
        const Text('日'),
        TextField(
          onChanged: (val) => _day = int.parse(val) ?? 0,
          maxLength: 2,
          keyboardType: const TextInputType.numberWithOptions(),
        ),
      ],
    );
  }

  Future<void> save() async {
    _story.updateTime = DateTime.now().toString();
    _story.createTime ??= DateTime.now().toString();
    _story.ageOfStory = '$_year-$_month-$_day';

    await SqlProvider().insertStory(_story);
  }
}
