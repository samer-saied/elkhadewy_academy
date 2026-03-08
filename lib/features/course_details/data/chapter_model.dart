import 'package:cloud_firestore/cloud_firestore.dart';

class Chapter {
  final String title;
  final int orderIndex;
  final String content;
  final String? id;
  final String courseId;
  final Timestamp createdAt;
  final String videoUrl;
  final String createdBy;
  final List<String> attachments;

  Chapter({
    required this.title,
    required this.orderIndex,
    required this.content,
    this.id,
    required this.courseId,
    required this.createdAt,
    required this.videoUrl,
    required this.createdBy,
    required this.attachments,
  });

  // --- Factory Constructor for Firestore Mapping ---
  // Accept both raw Map-like data and DocumentSnapshot-like objects.
  factory Chapter.fromFirestore(dynamic snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    List<String> attachmentsFiles = [];

    if (data['attachments'] != null && data['attachments'] is Iterable) {
      attachmentsFiles = List<String>.from(
        (data['attachments'] as Iterable).map((e) => e.toString()),
      );
    }

    return Chapter(
      id: snapshot.id,
      title: data['title']?.toString() ?? 'Untitled Chapter',
      orderIndex: (data['orderIndex'] as num?)?.toInt() ?? 0,
      content: data['content']?.toString() ?? 'No content available.',
      courseId: data['courseId']?.toString() ?? '',
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt'] as Timestamp
          : Timestamp.now(),
      videoUrl: data['videoUrl']?.toString() ?? '',
      createdBy: data['createdBy']?.toString() ?? 'admin',
      attachments: attachmentsFiles,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'orderIndex': orderIndex,
      'content': content,
      'courseId': courseId,
      'createdAt': createdAt,
      'videoUrl': videoUrl,
      'createdBy': createdBy,
      'attachments': attachments,
    };
  }
}
