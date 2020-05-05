import 'package:flutter/material.dart';
import 'package:storyadvancer/pages/edit_story_page.dart';
import 'package:storyadvancer/pages/titles_page.dart';

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
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイトル'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            // ignore: lines_longer_than_80_chars
            onPressed: () async => Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                builder: (context) {
                  return const EditStoryPage();
                },
              ),
            ),
          ),
        ],
      ),
      body: TitlesPage(),
    );
  }
}
