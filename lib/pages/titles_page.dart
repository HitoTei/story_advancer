import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/model/story.dart';

class TitlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Story>>(
      future: SqlProvider().getStoriesWithoutContent(),
      builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        if (snapshot.hasError) return Text('エラーが発生しました: ${snapshot.error}');

        return Column(
          children: <Widget>[
            for (var story in snapshot.data)
              Column(children: [
                Text('title:${(story.title ?? 'null')}'),
                Text('作成日時: ${story.createTime}'),
                Text('更新日時: ${story.updateTime}'),
                Text('id :${story.id}'),
              ]),
          ],
        );
      },
    );
  }
}
