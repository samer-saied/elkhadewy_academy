import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/courses/data/models/course_model.dart';

import '../../../../core/remote/firebase_firestore_service.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../auth/models/user_model.dart';

part 'request_show_course_state.dart';

class RequestShowCourseCubit extends Cubit<RequestShowCourseState> {
  final FirebaseFirestoreService _service;
  RequestShowCourseCubit(this._service) : super(RequestShowCourseInitial());

  final String collectionId = "request_show_course";

  Future<void> requestShowCourse({required CourseModel course}) async {
    emit(RequestShowCourseLoading());
    UserModel? currentUser = GetIt.I<LoginCubit>().currentUser;
    try {
      QuerySnapshot<Object?> docs = await _service.getDocuments(
        collectionId: collectionId,
        where: {'courseId': course.id, "studentId": currentUser!.id},
      );
      if (docs.docs.isNotEmpty) {
        emit(
          RequestShowCourseLoaded(
            isSuccess: false,
            message:
                "Request Already sent before, Contact administrator to confirm your request",
          ),
        );
      } else {
        await _service.addDocument(
          collectionId: collectionId,
          data: {
            "courseId": course.id,
            "courseTitle": course.title,
            "studentId": currentUser!.id,
            "studentName": currentUser.name,
            "studentPhone": currentUser.phone,
            "createdAt": DateTime.now(),
          },
        );
        emit(
          RequestShowCourseLoaded(
            isSuccess: true,
            message:
                "Request Send Successfully, Contact administrator to confirm your request",
          ),
        );
      }
    } catch (e) {
      emit(RequestShowCourseError(message: e.toString()));
    }
  }
}
