class LogReportModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String faculty;
  final String studyYear;
  final String type;
  final bool isSuccess;
  final String result;
  final String dateTime;

  LogReportModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.faculty,
    required this.studyYear,
    required this.type,
    required this.isSuccess,
    required this.result,
    required this.dateTime,
  });

  factory LogReportModel.fromJson(Map<String, dynamic> json, String id) {
    return LogReportModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      faculty: json['faculty'] ?? '',
      studyYear: json['studyYear'] ?? '',
      type: json['type'] ?? 'student',
      isSuccess: json['isSuccess'] ?? false,
      result: json['result'] ?? 'Unknown',
      dateTime: json['dateTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'faculty': faculty,
      'studyYear': studyYear,
      'type': type,
      'isSuccess': isSuccess,
      'result': result,
      'dateTime': dateTime,
    };
  }
}
