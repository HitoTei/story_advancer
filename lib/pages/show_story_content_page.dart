import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/model/story.dart';

class ShowStoryContentPage extends StatelessWidget {
  const ShowStoryContentPage(Story story) : _story = story;
  final Story _story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _story.title ?? '',
        ),
      ),
      body: _contentWidget(),
    );
  }

  Widget _contentWidget() {
    return FutureBuilder<String>(
      future: SqlProvider().getContent(_story),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError)
          return Text(
            'エラー: ${snapshot.error}',
          );
        if (!snapshot.hasData) return const CircularProgressIndicator();

        _story.content = snapshot.data as String;
        return SingleChildScrollView(
          child: Text(
            _story.content,
          ),
        );
      },
    );
  }
}
