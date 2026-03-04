part of 'course_cubit.dart';


@immutable
sealed class CourseState {}

final class CourseInitial extends CourseState {}

final class CourseLoading extends CourseState {}

final class CourseLoaded extends CourseState {
  final List<CourseModel> items;
  CourseLoaded({required this.items});
}

/// Emitted when a CRUD operation (add/update/delete) succeeds.
final class CourseOperationSuccess extends CourseState {
  final String message;
  CourseOperationSuccess({required this.message});
}

/// Emitted when a CRUD operation fails.
final class CourseOperationFailure extends CourseState {
  final String error;
  CourseOperationFailure({required this.error});
}

/// Emitted when a live listener updates the list.
final class CourseListening extends CourseState {
  final List<CourseModel> items;
  CourseListening({required this.items});
}
