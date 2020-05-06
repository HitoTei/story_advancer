class Story {
  Story({
    this.id = null,
    this.title = '',
    this.updateTime = null,
    this.createTime = null,
    this.ageOfStory = '0',
    this.content = '',
    this.location = '',
  });
  Story.fromMap(Map<String, dynamic> map) {
    id = map[idName] as int;
    title = map[titleName] as String;
    createTime = map[createTimeName] as String;
    updateTime = map[updateTimeName] as String;
    ageOfStory = map[ageOfStoryName] as String;
    location = map[locationName] as String;
    content = map[contentName] as String;
  }
  static const idName = 'id';
  static const titleName = 'title';
  static const createTimeName = 'createTime';
  static const updateTimeName = 'updateTime';
  static const ageOfStoryName = 'ageOfStory';
  static const locationName = 'location';
  static const contentName = 'content';

  int id; // id
  String title; // タイトル
  String createTime; // 作成日時
  String updateTime; // 更新時刻
  String ageOfStory; // 物語の中での時間
  String location; // 作中の場所
  String content; // 内容

  Map<String, dynamic> toMap() {
    final res = <String, dynamic>{
      idName: id,
      titleName: title,
      createTimeName: createTime,
      updateTimeName: updateTime,
      ageOfStoryName: ageOfStory,
      locationName: location,
      contentName: content,
    };
    return res;
  }
}
