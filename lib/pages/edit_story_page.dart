import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    var numList = <int>[];
    try {
      for (final str in story.ageOfStory.split('-')) {
        numList.add(int.parse(str));
      }
    } catch (e) {
      numList = [0, 0, 0];
    }
    _year = numList[0];
    _month = numList[1];
    _day = numList[2];
  }

  bool isEdited = false;

  final Story _story;
  int _year = 0;
  int _month = 0;
  int _day = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: save,
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            const Text('タイトル'),
            TextFormField(
              initialValue: _story.title ?? '',
              onChanged: (val) {
                _story.title = val;
                isEdited = true;
              },
            ),
            const Text('本文'),
            TextFormField(
              initialValue: _story.content ?? '',
              onChanged: (val) {
                _story.content = val;
                isEdited = true;
              },
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            const Text('場所'),
            TextFormField(
              initialValue: _story.location ?? '',
              onChanged: (val) {
                _story.location = val;
                isEdited = true;
              },
            ),
            _ageOfStoryWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (isEdited) save();
    super.dispose();
  }

  Widget _ageOfStoryWidget() {
    return Column(
      children: <Widget>[
        const Text('年'),
        TextFormField(
          initialValue: _year.toString(),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          onChanged: (val) {
            _year = int.parse(val) ?? 0;
            isEdited = true;
          },
          keyboardType: const TextInputType.numberWithOptions(),
        ),
        const Text('月'),
        TextFormField(
          initialValue: _month.toString(),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          onChanged: (val) {
            _month = int.parse(val) ?? 0;
            isEdited = true;
          },
          maxLength: 2,
          keyboardType: const TextInputType.numberWithOptions(),
        ),
        const Text('日'),
        TextFormField(
          initialValue: _day.toString(),
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          onChanged: (val) {
            _day = int.parse(val) ?? 0;
            isEdited = true;
          },
          maxLength: 2,
          keyboardType: const TextInputType.numberWithOptions(),
        ),
      ],
    );
  }

  Future<void> save() async {
    isEdited = false;

    final time = DateTime.now().toString();
    _story.updateTime = time;
    _story.createTime ??= time;
    _story.ageOfStory = '$_year-$_month-$_day';

    await SqlProvider().insertStory(_story);
    Fluttertoast.showToast(
      msg: '保存しました',
    );
  }
}
