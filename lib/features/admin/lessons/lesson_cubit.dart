// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'lesson_state.dart';

// class LessonCubit extends Cubit<LessonState> {
//   LessonCubit() : super(const LessonState());

//   void updateTitle(String value) => emit(state.copyWith(title: value));
//   void updateDescription(String value) =>
//       emit(state.copyWith(description: value));
//   void updateCourse(String? value) =>
//       emit(state.copyWith(selectedCourse: value));

//   void toggleFreePreview(bool value) =>
//       emit(state.copyWith(isFreePreview: value));
//   void toggleComments(bool value) =>
//       emit(state.copyWith(areCommentsEnabled: value));

//   void removeAttachment(int index) {
//     final newList = List<String>.from(state.attachments)..removeAt(index);
//     emit(state.copyWith(attachments: newList));
//   }

//   void saveLesson() async {
//     emit(state.copyWith(status: LessonStatus.loading));
//     // Simulate network delay
//     await Future.delayed(const Duration(seconds: 2));
//     emit(state.copyWith(status: LessonStatus.success));
//   }
// }
