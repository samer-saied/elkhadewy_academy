class WatchingReport {
  final String userName;
  final String userId;
  final String userPhone;
  final String courseId;
  final String courseName;
  final String courseColor;
  final String chapterId;
  final String chapterName;
  final DateTime startDate;
  final DateTime endDate;
  final String videoWatchedDuration;
  final bool videoWatchedFinished;

  WatchingReport({
    required this.userName,
    required this.userId,
    required this.userPhone,
    required this.courseId,
    required this.courseName,
    required this.courseColor,
    required this.chapterId,
    required this.chapterName,
    required this.startDate,
    required this.endDate,
    required this.videoWatchedDuration,
    required this.videoWatchedFinished,
  });

  factory WatchingReport.fromJson(Map<String, dynamic> json) {
    return WatchingReport(
      userName: json['userName'],
      userId: json['userId'],
      userPhone: json['userPhone'],
      courseId: json['courseId'],
      courseName: json['courseName'],
      courseColor: json['courseColor'],
      chapterId: json['chapterId'],
      chapterName: json['chapterName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      videoWatchedDuration: json['videoWatchedDuration'],
      videoWatchedFinished: json['videoWatchedFinished'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userId': userId,
      'userPhone': userPhone,
      'courseId': courseId,
      'courseName': courseName,
      'courseColor': courseColor,
      'chapterId': chapterId,
      'chapterName': chapterName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'videoWatchedDuration': videoWatchedDuration,
      'videoWatchedFinished': videoWatchedFinished,
    };
  }
}
