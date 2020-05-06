import 'package:flutter/material.dart';
import 'package:storyadvancer/model/sql_provider.dart';
import 'package:storyadvancer/pages/edit_story_page.dart';
import 'package:storyadvancer/pages/titles_page.dart';
import 'package:storyadvancer/model/page_navigator.dart';
import 'model/story.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  Future<List<Story>> _future = SqlProvider().getStoriesWithoutContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイトル'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => PageNavigator().editStory(null, context)),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refresh,
          )
        ],
      ),
      body: TitlesPage(_future, this.refresh),
    );
  }

  Future<void> editStoryPage() async => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const EditStoryPage();
          },
        ),
      );
  void refresh() {
    setState(() {
      _future = SqlProvider().getStoriesWithoutContent();
    });
  }
}
