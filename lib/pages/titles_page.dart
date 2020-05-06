import 'package:flutter/material.dart';
import 'package:storyadvancer/model/story.dart';
import 'package:storyadvancer/pages/edit_story_page.dart';
import 'package:storyadvancer/pages/show_story_content_page.dart';

class TitlesPage extends StatelessWidget {
  const TitlesPage(Future<List<Story>> future) : _future = future;
  final Future<List<Story>> _future;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Story>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          if (snapshot.hasError) return Text('エラーが発生しました: ${snapshot.error}');

          final navigator = TitlesPageNavigator();

          return Column(
            children: <Widget>[
              for (var story in snapshot.data)
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
                    Text('id :${story.id}'),
                  ]),
                  onPressed: () => navigator.showStory(story, context),
                  onLongPress: () => navigator.editStory(story, context),
                ),
            ],
          );
        },
      ),
    );
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
