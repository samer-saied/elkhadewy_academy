import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/courses/data/models/course_model.dart';

import '../../../../core/remote/firebase_firestore_service.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../auth/repository/auth_repository.dart';
import '../../../auth/models/user_model.dart';

part 'request_show_course_state.dart';

class RequestShowCourseCubit extends Cubit<RequestShowCourseState> {
  final FirebaseFirestoreService _service;
  RequestShowCourseCubit(this._service) : super(RequestShowCourseInitial());

  final String collectionId = "request_show_course";
  List<Map> requestsData = [];

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
            "studentId": currentUser.id,
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

  Future<void> getPendingRequests() async {
    emit(RequestShowCourseLoading());
    requestsData.clear();

    try {
      if (GetIt.I<LoginCubit>().currentUser!.role == "admin") {
        ////////////////////// ADMIN  /////////////////////
        QuerySnapshot<Object?> data = await _service.getDocuments(
          collectionId: collectionId,
          where: {},
        );

        List<QueryDocumentSnapshot<Object?>> docs = data.docs;
        requestsData = docs.map((doc) {
          final map = doc.data() as Map<String, dynamic>;
          map['docId'] = doc.id;
          return map;
        }).toList();
      } else {
        ////////////////////// TEACHER  /////////////////////
        List<String> materials = GetIt.I<LoginCubit>().currentUser!.materials;

        for (var material in materials) {
          QuerySnapshot<Object?> data = await _service.getDocuments(
            collectionId: collectionId,
            where: {"courseId": material},
          );
          requestsData.addAll(
            data.docs.map((doc) {
              final map = doc.data() as Map<String, dynamic>;
              map['docId'] = doc.id;
              return map;
            }),
          );
        }
      }

      emit(PendingRequestsLoaded(requests: requestsData));
    } catch (e) {
      emit(RequestShowCourseError(message: e.toString()));
    }
  }

  // Future<void> getPendingMaterialRequests() async {
  //   emit(RequestShowCourseLoading());
  //   try {
  //     requestsData.clear();
  //     List<String> materials = GetIt.I<LoginCubit>().currentUser!.materials;
  //     for (var material in materials) {
  //       QuerySnapshot<Object?> data = await _service.getDocuments(
  //         collectionId: collectionId,
  //         where: {"courseId": material},
  //       );
  //       requestsData.addAll(data.docs.map((doc) => doc.data() as Map));
  //     }
  //     emit(PendingRequestsLoaded(requests: requestsData));
  //   } catch (e) {
  //     emit(RequestShowCourseError(message: e.toString()));
  //   }
  // }

  Future<void> acceptRequest({required Map request}) async {
    emit(RequestShowCourseLoading());
    try {
      // 1. Get student user document
      final studentDoc = await _service.getDocument(
        collectionId: 'users',
        documentId: request['studentId'],
      );

      if (studentDoc.exists) {
        UserModel student = UserModel.fromFirestore(studentDoc);

        // 2. Add course to student materials if not already present
        if (!student.materials.contains(request['courseId'])) {
          student.materials.add(request['courseId']);
          await GetIt.I<AuthRepository>().updateUser(student);
        }

        // 3. Delete the request and refresh list
        await _service.deleteDocument(
          collectionId: collectionId,
          documentId: request['docId'],
        );
        await getPendingRequests();
      } else {
        emit(const RequestShowCourseError(message: "Student not found"));
      }
    } catch (e) {
      emit(RequestShowCourseError(message: e.toString()));
    }
  }

  Future<void> deleteRequest({required String requestId}) async {
    emit(RequestShowCourseLoading());
    try {
      await _service.deleteDocument(
        collectionId: collectionId,
        documentId: requestId,
      );
      await getPendingRequests();
    } catch (e) {
      emit(RequestShowCourseError(message: e.toString()));
    }
  }
}
