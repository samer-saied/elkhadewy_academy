part of 'request_show_course_cubit.dart';

sealed class RequestShowCourseState extends Equatable {
  const RequestShowCourseState();

  @override
  List<Object> get props => [];
}

final class RequestShowCourseInitial extends RequestShowCourseState {}

final class RequestShowCourseLoading extends RequestShowCourseState {}

final class RequestShowCourseLoaded extends RequestShowCourseState {
  final bool isSuccess;
  final String message;
  const RequestShowCourseLoaded({
    required this.isSuccess,
    required this.message,
  });
}

final class RequestShowCourseError extends RequestShowCourseState {
  final String message;
  const RequestShowCourseError({required this.message});
}
