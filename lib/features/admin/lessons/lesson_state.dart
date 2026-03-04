// import 'package:equatable/equatable.dart';

// enum LessonStatus { initial, loading, success, error }

// class LessonState extends Equatable {
//   final String title;
//   final String description;
//   final String? selectedCourse;
//   final bool isFreePreview;
//   final bool areCommentsEnabled;
//   final List<String> attachments; // Mocking file paths/names
//   final LessonStatus status;

//   const LessonState({
//     this.title = '',
//     this.description = '',
//     this.selectedCourse,
//     this.isFreePreview = false,
//     this.areCommentsEnabled = true,
//     this.attachments = const ['ملخص الدرس الأول.pdf'],
//     this.status = LessonStatus.initial,
//   });

//   LessonState copyWith({
//     String? title,
//     String? description,
//     String? selectedCourse,
//     bool? isFreePreview,
//     bool? areCommentsEnabled,
//     List<String>? attachments,
//     LessonStatus? status,
//   }) {
//     return LessonState(
//       title: title ?? this.title,
//       description: description ?? this.description,
//       selectedCourse: selectedCourse ?? this.selectedCourse,
//       isFreePreview: isFreePreview ?? this.isFreePreview,
//       areCommentsEnabled: areCommentsEnabled ?? this.areCommentsEnabled,
//       attachments: attachments ?? this.attachments,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     title,
//     description,
//     selectedCourse,
//     isFreePreview,
//     areCommentsEnabled,
//     attachments,
//     status,
//   ];
// }
