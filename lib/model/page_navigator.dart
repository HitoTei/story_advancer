import 'package:flutter/material.dart';
import 'package:storyadvancer/model/story.dart';
import 'package:storyadvancer/pages/edit_story_page.dart';
import 'package:storyadvancer/pages/show_story_content_page.dart';

class PageNavigator {
  PageNavigator(void Function() refresh) : _refresh = refresh;
  final void Function() _refresh;

  Future<void> editStory(Story story, BuildContext context) async {
    await Navigator.of(context).push<Future<void>>(
      MaterialPageRoute(
        builder: (context) {
          return EditStoryPage(
            story: story,
          );
        },
      ),
    );

    _refresh();
  }

  Future<void> showStory(Story story, BuildContext context) async {
    await Navigator.of(context).push<ShowStoryContentPage>(
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
