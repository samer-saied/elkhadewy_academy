import 'package:bloc/bloc.dart';
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
  bool isContinue = false;

  Future<void> getWatchingReports({required String userId}) async {
    emit(WatchingReportLoading());

    try {
      final reports = await _service.getCollectionsByField(
        collectionId: collectionID,
        filterField: 'userId',
        filterValue: userId,
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
        filterValue: selectedDate,
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

  Future<void> getLastWatchingReport() async {
    if (isContinue) {
      emit(LastWatchingReportLoaded(report: lastWatchingReports));
      return;
    }
    emit(WatchingReportLoading());

    try {
      final reports = await _service.getCollectionsByField(
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
      emit(LastWatchingReportLoaded(report: lastWatchingReports));
    } catch (e) {
      emit(WatchingReportError(message: e.toString()));
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
}
