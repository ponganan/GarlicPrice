import 'package:cloud_firestore/cloud_firestore.dart';

class TopicList {
  String id;
  String uID;
  String topicPic;

  final String topic;
  final String topicDetail;

  final DateTime datePost;

  TopicList({
    this.id = '',
    required this.uID,
    this.topicPic = '',
    required this.topic,
    required this.topicDetail,
    required this.datePost,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uID': uID,
        'topicPic': topicPic,
        'topic': topic,
        'topicDetail': topicDetail,
        'datePost': datePost,
      };

  static TopicList fromJson(Map<String, dynamic> json) => TopicList(
        id: json['id'],
        uID: json['uID'],
        topicPic: json['topicPic'],
        topic: json['topic'],
        topicDetail: json['topicDetail'],
        datePost: (json['datePost'] as Timestamp).toDate(),
      );
}
