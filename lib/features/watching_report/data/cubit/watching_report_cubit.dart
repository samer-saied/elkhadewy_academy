import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/remote/firebase_firestore_service.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../model/watching_model.dart';

part 'watching_report_state.dart';

class WatchingReportCubit extends Cubit<WatchingReportState> {
  final FirebaseFirestoreService _service;
  WatchingReportCubit(this._service) : super(WatchingReportInitial());

  final String collectionID = 'watching_reports';

  List<WatchingReport> watchingReports = [];
  late WatchingReport lastWatchingReports;
  List<Map<String, dynamic>> weeklyCountReport = [];
  bool isContinue = false;
  List<Map<String, dynamic>> dailyCounts = [];

  Future<void> getWatchingReports({required String userId}) async {
    emit(WatchingReportLoading());

    try {
      final reports = await _service.getCollections4LastWatchingReport(
        collectionId: collectionID,
        filterField: 'userId',
        filterValue: userId,
        isAscending: false,
        orderByField: 'startDate',
      );
      watchingReports = reports
          .map(
            (doc) =>
                WatchingReport.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      emit(WatchingReportLoaded(reports: watchingReports));
    } catch (e) {
      emit(WatchingReportError(message: e.toString()));
    }
  }

  Future<void> getWatchingReportsByPhone({required String phone}) async {
    emit(WatchingReportLoading());

    try {
      final reports = await _service.getCollectionsByField(
        collectionId: collectionID,
        filterField: 'userPhone',
        filterValue: phone,
        isAscending: false,
        orderByField: 'startDate',
      );

      watchingReports = reports
          .map(
            (doc) =>
                WatchingReport.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      emit(WatchingReportLoaded(reports: watchingReports));
    } catch (e) {
      emit(WatchingReportError(message: e.toString()));
    }
  }

  Future<void> getWatchingReportsByDate({required String selectedDate}) async {
    emit(WatchingReportLoading());

    try {
      final reports = await _service.getCollectionsByField(
        collectionId: collectionID,
        filterField: 'startDate',
        isGreaterThanOrEqualTo: selectedDate,
        isLessThan: DateTime.parse(
          selectedDate,
        ).add(const Duration(days: 1)).toString().split(' ')[0],
      );

      watchingReports = reports
          .map(
            (doc) =>
                WatchingReport.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      emit(WatchingReportLoaded(reports: watchingReports));
    } catch (e) {
      emit(WatchingReportError(message: e.toString()));
    }
  }

  Future<dynamic> getLastWatchingReport() async {
    // if (isContinue) {
    //   return lastWatchingReports;
    // }
    try {
      final reports = await _service.getCollections4LastWatchingReport(
        collectionId: collectionID,
        filterField: 'userId',
        filterValue: GetIt.I.get<LoginCubit>().currentUser!.id,
        limit: 1,
        orderByField: 'startDate',
        isAscending: false,
      );

      lastWatchingReports = WatchingReport.fromJson(
        reports.first.data() as Map<String, dynamic>,
      );
      isContinue = true;
      return lastWatchingReports;
    } catch (e) {
      // emit(WatchingReportError(message: e.toString()));
      return null;
    }
  }

  Future<void> addWatchingReport({
    required WatchingReport watchingReport,
  }) async {
    await _service.addDocument(
      collectionId: collectionID,
      data: watchingReport.toJson(),
    );
  }

  Future<void> getWeeklyCountReport() async {
    emit(WatchingReportLoading());

    try {
      // Get current date at midnight
      dailyCounts.clear();
      DateTime now = DateTime.now();

      for (int i = 0; i < 7; i++) {
        int snapshot = await _service.getDocumentsCountsByDate(
          collectionId: collectionID,
          field: 'startDate',
          valueDate: now,
        );

        dailyCounts.add({
          "date": now.toString().split(' ')[0],
          "counts": snapshot,
        });
        now = now.subtract(const Duration(days: 1));
      }

      emit(WatchingReportLoaded(reports: watchingReports));
    } catch (e) {
      emit(WatchingReportError(message: e.toString()));
    }
  }
}
