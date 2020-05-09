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
  HomeState();
  Future<List<Story>> _future = SqlProvider().getStoriesWithoutContent();
  PageNavigator _navigator;

  @override
  Widget build(BuildContext context) {
    _navigator = PageNavigator(refresh);

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイトル'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigator.editStory(null, context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refresh,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () async {
              await showDialog<SimpleDialog>(
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.all(20),
                    title: const Text('並び順'),
                    children: [
                      SortConditionWidget(),
                    ],
                  );
                },
              );
              refresh();
            },
          )
        ],
      ),
      body: TitlesPage(_future, refresh, _navigator),
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
