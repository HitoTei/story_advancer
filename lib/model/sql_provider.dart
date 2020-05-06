import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:storyadvancer/model/story.dart';

class SqlProvider {
  static const _tableName = 'stories';
  SqlProvider() {
    _db = initDatabase();
  }

  Future<Database> _db;
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'stories.db'),
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE '
          '$_tableName('
          '${Story.idName} INTEGER PRIMARY KEY AUTOINCREMENT,'
          '${Story.titleName} TEXT,'
          '${Story.createTimeName} TEXT,'
          '${Story.updateTimeName} TEXT,'
          '${Story.ageOfStoryName} TEXT,'
          '${Story.locationName} TEXT,'
          '${Story.contentName} TEXT'
          ');',
        );
      },
      version: 3,
    );
  }

  Future<void> insertStory(Story story) async {
    final db = await _db;

    db.insert(
      _tableName,
      story.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteStory(Story story) async {
    final db = await _db;
    db.delete(
      _tableName,
      where: '${Story.idName} = ?',
      whereArgs: <dynamic>[story.id],
    );
  }

  Future<String> getContent(Story story) async {
    final db = await _db;
    final tmp = await db.query(
      _tableName,
      columns: [
        Story.contentName,
      ],
      where: '${Story.idName} = ?',
      whereArgs: <dynamic>[story.id],
    );

    Story res;
    try {
      res = Story.fromMap(tmp[0]);
    } catch (e) {
      return '';
    }
    return res.content;
  }

  // contentはnull
  Future<List<Story>> getStoriesWithoutContent() async {
    final db = await _db;
    final stories = await db.query(
      _tableName,
      columns: [
        Story.idName,
        Story.createTimeName,
        Story.locationName,
        Story.ageOfStoryName,
        Story.updateTimeName,
        Story.titleName
      ],
    );

    final storyList = <Story>[];
    for (final story in stories) {
      storyList.add(Story.fromMap(story));
    }
    return storyList;
  }

  Future<List<Story>> getStories() async {
    final db = await _db;
    final stories = await db.query(_tableName);
    final storyList = <Story>[];
    for (final story in stories) {
      storyList.add(Story.fromMap(story));
    }
    return storyList;
  }

  Future<List<String>> getTitles() async {
    final db = await _db;
    final titles = await db.query(
      _tableName,
      columns: [Story.titleName],
    );

    final titleList = <String>[];
    for (final title in titles) {
      titleList.add(title[Story.titleName] as String);
    }
    return titleList;
  }
}
