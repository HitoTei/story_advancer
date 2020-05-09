import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/model/story.dart';
import 'package:storyadvancer/model/page_navigator.dart';

String _condition = Story.createTimeName; // なにでソートするか
bool _isAce = true; // 昇順かどうか

class TitlesPage extends StatelessWidget {
  const TitlesPage(Future<List<Story>> future, void Function() refresh,
      PageNavigator navigator)
      : _future = future,
        _refresh = refresh,
        _navigator = navigator;
  final Future<List<Story>> _future;
  final void Function() _refresh;
  final PageNavigator _navigator;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${story.title ?? '無題'}',
                    style: const TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  Text(
                    '${story.processedAgeOfStory()}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '場所: ${story.location}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '作成日時: ${story.createTime}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '更新日時: ${story.updateTime}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              titleOperations(context, story),
            ],
          ),
        ],
      ),
      onPressed: () => _navigator.showStory(story, context),
      onLongPress: () async {
        await _navigator.editStory(story, context);
        _refresh();
      },
    );
  }

  Widget titleOperations(BuildContext context, Story story) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
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
        Expanded(
          child: Column(
            children: [
              Text(_isAce ? '昇順' : '降順'),
              Switch(
                value: _isAce,
                onChanged: (bool val) => setState(() => _isAce = val),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget radioTile(String title, String value) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(title),
          Radio(
            value: value,
            groupValue: _condition,
            onChanged: (String val) => setState(() => _condition = val),
          ),
        ],
      ),
    );
  }
}
