// ignore_for_file: unnecessary_null_comparison

class CategoryModel {
  final String? id;
  final String title;
  final String? subtitle;
  final String? color;
  // final List<String> academicYears;

  CategoryModel({
    this.id,
    required this.title,
    this.subtitle,
    this.color,
    // this.academicYears = const ["1st Year", "2nd Year", "3rd Year", "4th Year"],
  });

  factory CategoryModel.fromFirestore(var snapshot, String idCode) {
    return CategoryModel(
      id: idCode,
      title: snapshot['title'],
      subtitle: snapshot['subtitle'] ?? snapshot['title'],
      color: snapshot['color'] ?? "color",
      // academicYears:
      //     snapshot['academicYears'] ??
      //     const ["1st Year", "2nd Year", "3rd Year", "4th Year"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (subtitle != null) "subtitle": subtitle,
      if (color != null) "color": color,
      // if (academicYears != null) "academicYears": academicYears,
    };
  }
}
