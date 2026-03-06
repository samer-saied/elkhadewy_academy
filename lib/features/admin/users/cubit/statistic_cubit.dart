import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:unimind/core/remote/firebase_firestore_service.dart';
import 'package:unimind/features/auth/models/user_model.dart';

part 'statistic_state.dart';

class StatisticCubit extends Cubit<StatisticState> {
  final FirebaseFirestoreService _service;

  StatisticCubit(this._service) : super(StatisticInitial());

  final String collectionID = 'users';
  Map<String, int> results = {};
  List<UserModel> users = [];
  Future<void> getUsersCount() async {
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

  Future<void> getUsersData({
    required String role,
    required String value,
  }) async {
    emit(StatisticLoading());
    try {
      final List<QueryDocumentSnapshot> docs = await _service
          .getCollectionsByField(
            collectionId: collectionID,
            filterField: role,
            filterValue: value,
          );
      users = docs.map((doc) => UserModel.fromFirestore(doc)).toList();
      emit(StatisticLoaded());
    } catch (e) {
      emit(const StatisticLoaded());
    }
  }
}
