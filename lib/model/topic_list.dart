class TopicList {
  String id;
  final String topicPic;
  final String topic;

  TopicList({
    this.id = '',
    required this.topicPic,
    required this.topic,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'topicpic': topicPic,
        'topic': topic,
      };

  static TopicList fromJson(Map<String, dynamic> json) => TopicList(
        id: json['id'],
        topicPic: json['topicpic'],
        topic: json['topic'],
      );
}
