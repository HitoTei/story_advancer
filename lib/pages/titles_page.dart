import 'package:flutter/material.dart';
import 'package:storyadvancer/model/story.dart';
import 'package:storyadvancer/pages/edit_story_page.dart';
import 'package:storyadvancer/pages/show_story_content_page.dart';

String _condition = Story.createTimeName; // なにでソートするか
bool _isAce = true; // 昇順かどうか

class TitlesPage extends StatelessWidget {
  const TitlesPage(Future<List<Story>> future) : _future = future;
  final Future<List<Story>> _future;

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

            final navigator = TitlesPageNavigator();
            final stories = snapshot.data;
            sortStories(stories);
            return Column(
              children: <Widget>[
                for (var story in stories)
                  Column(
                    children: <Widget>[
                      FlatButton(
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
                          Text('作品内時間 :${story.processedAgeOfStory()}'),
                        ]),
                        onPressed: () => navigator.showStory(story, context),
                        onLongPress: () => navigator.editStory(story, context),
                      ),
                      const Divider(),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
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

class TitlesPageNavigator {
  Future<void> editStory(Story story, BuildContext context) async {
    return Navigator.of(context).push<EditStoryPage>(
      MaterialPageRoute(
        builder: (context) {
          return EditStoryPage(
            story: story,
          );
        },
      ),
    );
  }

  Future<void> showStory(Story story, BuildContext context) async {
    return Navigator.of(context).push<EditStoryPage>(
      MaterialPageRoute(
        builder: (context) {
          return ShowStoryContentPage(
            story,
          );
        },
      ),
    );
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
        radioTile(Story.createTimeName),
        radioTile(Story.updateTimeName),
        radioTile(Story.ageOfStoryName),
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

  Widget radioTile(String value) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(value),
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
