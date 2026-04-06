class InfoChipModel {
  final String courseTitle;
  final String courseId;
  final String courseColor;
  final String? courseDescription;
  final int countStudents;
  final int totalStudents;

  InfoChipModel({
    required this.courseTitle,
    required this.courseId,
    required this.courseColor,
    this.courseDescription,
    required this.countStudents,
    required this.totalStudents,
  });

  factory InfoChipModel.fromJson(Map<String, dynamic> json) {
    return InfoChipModel(
      courseTitle: json['course_title']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      courseColor: json['course_color']?.toString() ?? "0xFF000000",
      courseDescription: json['course_description']?.toString(),
      countStudents: json['count_students'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'course_id': courseId,
      'course_color': courseColor,
      'course_description': courseDescription,
      'count_students': countStudents,
      'total_students': totalStudents,
    };
  }
}
