import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/model/story.dart';
import 'package:storyadvancer/model/page_navigator.dart';

String _condition = Story.createTimeName; // なにでソートするか
bool _isAce = true; // 昇順かどうか

class TitlesPage extends StatelessWidget {
  const TitlesPage(Future<List<Story>> future, void Function() refresh)
      : _future = future,
        _refresh = refresh;
  final Future<List<Story>> _future;
  final void Function() _refresh;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SortConditionWidget(),
        FutureBuilder<List<Story>>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            if (snapshot.hasError) return Text('エラーが発生しました: ${snapshot.error}');

            final stories = snapshot.data;
            sortStories(stories);

            return Column(
              children: <Widget>[
                for (var story in stories)
                  Column(
                    children: <Widget>[
                      const Divider(),
                      _titleWidget(story, context),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _titleWidget(Story story, BuildContext context) {
    return FlatButton(
      child: Column(children: [
        Text(
          'title:${story.title ?? '無題'}',
        ),
        Text(
          '作成日時: ${story.createTime}',
        ),
        Text(
          '更新日時: ${story.updateTime}',
        ),
        Text(
          '作内時間 :${story.processedAgeOfStory()}',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            titleOperations(context, story),
          ],
        )
      ]),
      onPressed: () => PageNavigator().showStory(story, context),
      onLongPress: () => PageNavigator().editStory(story, context),
    );
  }

  Widget titleOperations(BuildContext context, Story story) {
    return IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () async => showDialog<SimpleDialog>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              FlatButton(
                onPressed: () async => showDialog<AlertDialog>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('本当に削除しますか？'),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              SqlProvider().deleteStory(story);
                              _refresh();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    }),
                child: const Text('削除'),
              )
            ],
          );
        },
      ),
    );
  }

  void sortStories(List<Story> stories) {
    switch (_condition) {
      case Story.createTimeName:
        stories.sort((Story s1, Story s2) =>
            s1.createTime.compareTo(s2.createTime) * (_isAce ? 1 : -1));
        break;
      case Story.updateTimeName:
        stories.sort((Story s1, Story s2) =>
            s1.updateTime.compareTo(s2.updateTime) * (_isAce ? 1 : -1));
        break;
      case Story.ageOfStoryName:
        stories.sort((Story s1, Story s2) =>
            s1.ageOfStory.compareTo(s2.ageOfStory) * (_isAce ? 1 : -1));
        break;
    }
  }
}

class SortConditionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SortConditionState();
  }
}

class _SortConditionState extends State<SortConditionWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        radioTile('作成時間', Story.createTimeName),
        radioTile('更新時間', Story.updateTimeName),
        radioTile('作内時間', Story.ageOfStoryName),
        Column(children: [
          Text(_isAce ? '昇順' : '降順'),
          Switch(
            value: _isAce,
            onChanged: (bool val) => setState(() => _isAce = val),
          ),
        ])
      ],
    );
  }

  Widget radioTile(String title, String value) {
    return Column(
      children: <Widget>[
        Text(title),
        Radio(
          value: value,
          groupValue: _condition,
          onChanged: (String val) => setState(() => _condition = val),
        ),
      ],
    );
  }
}
