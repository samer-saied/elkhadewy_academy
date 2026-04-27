import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/remote/firebase_firestore_service.dart';
import '../../../auth/models/user_model.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/presentations/cubit/course_cubit.dart';
import '../models/info_chip_model.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final FirebaseFirestoreService _service;

  StatisticCubit(this._service) : super(StatisticInitial());

  final String collectionID = 'users';
  Map<String, int> results = {};
  List<UserModel> users = [];
  List<InfoChipModel> infoChips = [];
  String selectedFacultyValue = "BIS";
  int selectedAcademicYear = 0;

  /// Get All Users Count ///////
  Future<void> getUsersStatusCount() async {
    emit(StatisticLoading());
    int users = await _service.getDocumentsCount(collectionId: collectionID);

    int students = await _service.getDocumentsCount(
      collectionId: collectionID,
      field: "role",
      value: "student",
    );
    int admins = await _service.getDocumentsCount(
      collectionId: collectionID,
      field: "role",
      value: "admin",
    );
    int teachers = await _service.getDocumentsCount(
      collectionId: collectionID,
      field: "role",
      value: "teacher",
    );
    int activeStudents = await _service.getDocumentsCount(
      collectionId: collectionID,
      field: "status",
      value: "active",
    );
    int blockedStudents = await _service.getDocumentsCount(
      collectionId: collectionID,
      field: "status",
      value: "blocked",
    );

    results = {
      "users": users,
      "admins": admins,
      "students": students,
      "teachers": teachers,
      "activeStudents": activeStudents,
      "blockedStudents": blockedStudents,
    };

    emit(StatisticLoaded());
  }

  Future<int> getCourseStudentsCount(String courseId) async {
    int count = await _service.getDocumentsCountByList(
      collectionId: 'users',
      field: "role",
      value: "student",
      field2: 'materials',
      value2: courseId,
    );
    return count;
  }

  Future<List<UserModel>> getUsersDataBySearch({
    required String searchValue,
    required String searchField,
  }) async {
    if (searchValue.trim().isEmpty || searchValue.trim().length < 3) {
      users.clear();
      emit(StatisticLoaded());
      return [];
    }
    emit(StatisticLoading());
    try {
      final List<QueryDocumentSnapshot> docs = await _service
          .getCollectionBySearch(
            collectionId: collectionID,
            searchValue: searchValue,
            searchField: searchField,
          );
      users = docs.map((doc) => UserModel.fromFirestore(doc)).toList();
      emit(StatisticLoaded());
      return users;
    } catch (e) {
      emit(StatisticLoaded());
      return [];
    }
  }

  Future<List<UserModel>> getUsersData({
    required String role,
    required String value,
    String? role2,
    String? value2,
  }) async {
    emit(StatisticLoading());
    try {
      final List<QueryDocumentSnapshot> docs = await _service
          .getCollectionsByField(
            collectionId: collectionID,

            filterField: role,
            filterValue: value,
            filterField2: role2,
            filterValue2: value2,
          );
      users = docs.map((doc) => UserModel.fromFirestore(doc)).toList();
      emit(StatisticLoaded());
      return users;
    } catch (e) {
      emit(StatisticLoaded());
      return [];
    }
  }

  Future<List<UserModel>> getUsersDataByMaterial({
    required String materialId,
  }) async {
    emit(StatisticLoading());
    try {
      final List<QueryDocumentSnapshot> docs = await _service
          .getCollectionsByList(
            collectionId: collectionID,
            filterField: 'materials',
            filterValue: materialId,
            filterField2: 'role',
            filterValue2: 'student',
          );
      users = docs.map((doc) => UserModel.fromFirestore(doc)).toList();

      emit(StatisticLoaded());
      return users;
    } catch (e) {
      emit(StatisticLoaded());
      return [];
    }
  }

  getCountStudentsByFaculty({String? selectedFaculty}) async {
    emit(StatisticLoading());
    infoChips.clear();

    await GetIt.I.get<CourseCubit>().fetchSpecificCoursesByCollegeTitle(
      selectedFaculty ?? selectedFacultyValue,
      (selectedAcademicYear + 1).toString(),
    );

    List<CourseModel> courses = GetIt.I.get<CourseCubit>().specificCourses;

    int totalCount = await _service.getDocumentsCount(
      collectionId: 'users',
      field: 'faculty',
      value: selectedFacultyValue.toUpperCase(),
      field2: 'studyYear',
      value2: (selectedAcademicYear).toString(),
    );

    for (var course in courses) {
      int count = await getCourseStudentsCount(course.id!);
      InfoChipModel infoCard = InfoChipModel(
        countStudents: count,
        totalStudents: totalCount,
        courseTitle: course.title,
        courseId: course.id ?? "None",
        courseColor: course.color.toString(),
        courseDescription: course.description,
      );
      infoChips.add(infoCard);
    }

    emit(StatisticLoaded());
  }

  getCountStudentsByMaterial([String? courseId]) async {
    emit(StatisticLoading());

    infoChips.clear();
    if (courseId != null) {
      int count = await getCourseStudentsCount(courseId);
      CourseModel? course = await GetIt.I.get<CourseCubit>().findLocalCourse(
        courseId,
      );
      InfoChipModel infoCard = InfoChipModel(
        countStudents: count,
        totalStudents: 0,
        courseTitle: course?.title ?? "Unknown Course",
        courseId: course?.id ?? "None",
        courseColor: course?.color.toString() ?? "0xFF000000",
        courseDescription: course?.description ?? "",
      );
      infoChips.add(infoCard);
    }
    emit(StatisticLoaded());
  }

  changeSelectedFaculty(String faculty) {
    selectedFacultyValue = faculty;
    getCountStudentsByFaculty();
  }

  changeSelectedAcademicYear(int index) {
    selectedAcademicYear = index;
    getCountStudentsByFaculty();
  }
}
