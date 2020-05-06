import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Text(
          _story.content ?? '',
        ),
      ),
    );
  }
}
