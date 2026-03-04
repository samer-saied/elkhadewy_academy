// ignore_for_file: unnecessary_null_comparison

class NewsItemModel {
  final String? id;
  final String title;
  final String description;
  final String? dateTime;
  final String? link;
  final String? priority;

  NewsItemModel({
    this.id,
    required this.title,
    required this.description,
    this.dateTime,
    this.link,
    this.priority = "normal",
  });

  factory NewsItemModel.fromFirestore(
    Map<String, dynamic> snapshot,
    String idCode,
  ) {
    return NewsItemModel(
      id: idCode,
      title: snapshot['title'],
      description: snapshot['description'],
      dateTime: snapshot['dateTime'] != null
          ? DateTime.tryParse(snapshot['dateTime']).toString()
          : DateTime.now().toString(),
      link: snapshot['link'] ?? "",
      priority: snapshot['priority'] ?? "normal",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (description != null) "description": description,
      if (dateTime != null) "date": dateTime,
      if (link != null) "link": link,
      if (priority != null) "priority": priority,
    };
  }
}
