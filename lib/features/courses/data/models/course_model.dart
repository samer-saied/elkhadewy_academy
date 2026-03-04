// ignore_for_file: unnecessary_null_comparison

class CourseModel {
  final String? id;
  final String title;
  final String description;
  final String? dateTime;
  final String? imgLink;
  final String? color;
  final String collegeId;
  final String collegeTitle;
  final String yearId;

  CourseModel({
    this.id,
    required this.title,
    required this.description,
    this.dateTime,
    this.imgLink,
    this.color,
    required this.collegeId,
    required this.collegeTitle,
    required this.yearId,
  });

  factory CourseModel.fromFirestore(var snapshot) {
    final raw =
        ((snapshot as dynamic).data?.call() ?? (snapshot as dynamic))
            as Map<String, dynamic>?;
    final data = raw ?? <String, dynamic>{};

    String? idValue;
    try {
      idValue = (snapshot as dynamic).id as String?;
    } catch (_) {
      idValue = null;
    }

    return CourseModel(
      id: idValue,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      dateTime:
          data['dateTime']?.toString() ?? DateTime.now().toIso8601String(),
      imgLink: data['imglink']?.toString() ?? '',
      color: data['color']?.toString(),
      collegeId: data['collegeId']?.toString() ?? "",
      collegeTitle: data['collegeTitle']?.toString() ?? "None",
      yearId: data['yearId']?.toString() ?? "None",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'collegeId': collegeId,
      'collegeTitle': collegeTitle,
      'yearId': yearId,
      'color': color,
      'description': description,
      'imglink': imgLink,
      'title': title,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? dateTime,
    String? imgLink,
    String? color,
    String? collegeId,
    String? collegeTitle,
    String? yearId,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      imgLink: imgLink ?? this.imgLink,
      color: color ?? this.color,
      collegeId: collegeId ?? this.collegeId,
      collegeTitle: collegeTitle ?? this.collegeTitle,
      yearId: yearId ?? this.yearId,
    );
  }
}
