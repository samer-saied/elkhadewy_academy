class Chapter {
  final String title;
  final int orderIndex;
  final String content;
  final List<String> sections;
  final String? id;
  final String courseId;

  Chapter({
    required this.title,
    required this.orderIndex,
    required this.content,
    required this.sections,
    this.id,
    required this.courseId,
  });

  // --- Factory Constructor for Firestore Mapping ---
  // Accept both raw Map-like data and DocumentSnapshot-like objects.
  factory Chapter.fromFirestore(dynamic snapshot) {
    final raw =
        ((snapshot as dynamic).data?.call() ?? (snapshot as dynamic))
            as Map<String, dynamic>?;
    final data = raw ?? <String, dynamic>{};

    final List<String> sectionsList =
        (data['sections'] as List<dynamic>?)?.cast<String>() ?? [];

    String? id;
    try {
      id = (snapshot as dynamic).id as String?;
    } catch (_) {
      id = null;
    }

    return Chapter(
      id: id,
      title: data['title']?.toString() ?? 'Untitled Chapter',
      orderIndex: (data['orderIndex'] is int)
          ? data['orderIndex'] as int
          : int.tryParse(data['orderIndex']?.toString() ?? '') ?? 0,
      content: data['content']?.toString() ?? 'No content available.',
      sections: sectionsList,
      courseId: data['courseId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'orderIndex': orderIndex,
      'content': content,
      'sections': sections,
      'courseId': courseId,
    };
  }
}
