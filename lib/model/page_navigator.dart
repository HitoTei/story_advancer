import 'package:flutter/material.dart';
import 'package:storyadvancer/model/story.dart';
import 'package:storyadvancer/pages/edit_story_page.dart';
import 'package:storyadvancer/pages/show_story_content_page.dart';

class PageNavigator {
  Future<void> editStory(Story story, BuildContext context) async {
    return Navigator.of(context).push(
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
    return Navigator.of(context).push(
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
