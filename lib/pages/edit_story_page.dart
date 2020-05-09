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
  _EditStoryState(Story story) : _store = EditStoryStore(story);
  final EditStoryStore _store;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_store.isEdited) {
          Navigator.pop(
            context,
            _store.save(),
          );
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _store.save,
            ),
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              _singleLineTextWidget(
                  title: 'タイトル',
                  varName: Story.titleName,
                  initialValue: _store.story.title),
              _contentWidget(),
              _singleLineTextWidget(
                  title: '場所',
                  varName: Story.locationName,
                  initialValue: _store.story.location),
              _ageOfStoryWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentWidget() {
    return Column(
      children: <Widget>[
        FutureBuilder<String>(
          future: SqlProvider().getContent(_store.story),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Text(
                'エラー:${snapshot.error}',
              );
            if (!snapshot.hasData) return const CircularProgressIndicator();

            _store.story.content = snapshot.data;

            return TextFormField(
              decoration: const InputDecoration(
                labelText: '本文',
              ),
              initialValue: _store.story.content,
              onChanged: (val) =>
                  _store.onChanged(value: val, varName: Story.contentName),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            );
          },
        ),
      ],
    );
  }

  Widget _singleLineTextWidget(
      {@required String title,
      @required String varName,
      @required String initialValue}) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: title,
          ),
          initialValue: initialValue ?? '',
          onChanged: (val) => _store.onChanged(value: val, varName: varName),
        )
      ],
    );
  }

  Widget _numTextWidget({@required String title, @required int initialValue}) {
    return Expanded(
      flex: (title == '年') ? 3 : 2,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: title,
        ),
        initialValue: initialValue.toString(),
        onChanged: (val) => _store.onChanged(value: val, varName: title),
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        maxLength: (title == '年') ? 10 : 2,
        keyboardType: const TextInputType.numberWithOptions(),
      ),
    );
  }

  Widget _ageOfStoryWidget() {
    return Row(
      children: <Widget>[
        _numTextWidget(title: '年', initialValue: _store.year),
        _numTextWidget(title: '月', initialValue: _store.month),
        _numTextWidget(title: '日', initialValue: _store.day),
      ],
    );
  }
}

class EditStoryStore {
  EditStoryStore(this.story) {
    story ??= Story();

    try {
      final numList = <int>[];
      for (final str in story.ageOfStory.split('-')) {
        numList.add(int.parse(str));
      }
      year = numList[0];
      month = numList[1];
      day = numList[2];
    } catch (e) {
      year = month = day = 0;
    }
  }
  Story story;
  int year, month, day;
  bool isEdited = false;

  void onChanged({@required String value, @required String varName}) {
    isEdited = true;

    switch (varName) {
      case Story.contentName:
        story.content = value;
        break;
      case Story.titleName:
        story.title = value;
        break;
      case Story.locationName:
        story.location = value;
        break;
      case '年':
        year = int.parse(value);
        break;
      case '月':
        month = int.parse(value);
        break;
      case '日':
        day = int.parse(value);
        break;
    }
  }

  Future<void> save() async {
    isEdited = false;

    final time = DateTime.now().toString();
    story
      ..updateTime = time
      ..createTime ??= time
      ..ageOfStory = '$year-$month-$day';

    await SqlProvider().insertStory(story);

    await Fluttertoast.showToast(
      msg: '保存しました',
    );
  }
}
