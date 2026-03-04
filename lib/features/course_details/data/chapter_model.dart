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

  Chapter({
    required this.title,
    required this.orderIndex,
    required this.content,
    this.id,
    required this.courseId,
    required this.createdAt,
    required this.videoUrl,
    required this.createdBy,
  });

  // --- Factory Constructor for Firestore Mapping ---
  // Accept both raw Map-like data and DocumentSnapshot-like objects.
  factory Chapter.fromFirestore(dynamic snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return Chapter(
      id: snapshot.id,
      title: data?['title']?.toString() ?? 'Untitled Chapter',
      orderIndex: (data?['orderIndex'] is int)
          ? data!['orderIndex'] as int
          : int.tryParse(data!['orderIndex']?.toString() ?? '') ?? 0,
      content: data['content']?.toString() ?? 'No content available.',
      courseId: data['courseId'],
      createdAt: data['createdAt'] ?? DateTime.now().toString(),
      videoUrl: data['videoUrl'] ?? '',
      createdBy: data['createdBy'] ?? 'admin',
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
    };
  }
}
