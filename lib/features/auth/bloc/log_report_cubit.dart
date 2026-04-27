import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/log_report_model.dart';
import '../repository/log_repository.dart';
import 'log_report_state.dart';

class LogReportCubit extends Cubit<LogReportState> {
  final LogRepository logRepository;

  LogReportCubit(this.logRepository) : super(LogReportState());

  bool _isFetching = false;

  Future<void> fetchLogReports({bool refresh = false}) async {
    if (state.hasReachedMax && !refresh) return;
    if (_isFetching) return;

    _isFetching = true;

    if (refresh || state.status == LogReportStatus.initial) {
      emit(LogReportState(status: LogReportStatus.loading, totalCount: 0));
    }

    try {
      final result = await logRepository.getLogReports(
        startAfterDocument: refresh ? null : state.lastDocument,
        limit: 10,
      );

      if (result is String) {
        emit(
          state.copyWith(
            status: LogReportStatus.failure,
            errorMessage: result,
            totalCount: 0,
          ),
        );
      } else if (result is List<QueryDocumentSnapshot>) {
        final docs = result;
        final newReports = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return LogReportModel.fromJson(data, doc.id);
        }).toList();

        final updatedReports = refresh
            ? newReports
            : (List<LogReportModel>.from(state.reports)..addAll(newReports));

        final hasReachedMax = docs.length < 10;
        final lastDocument = docs.isNotEmpty ? docs.last : state.lastDocument;
        final totalCount = await logRepository.getLogReportsCount();
        emit(
          state.copyWith(
            status: LogReportStatus.success,
            reports: updatedReports,
            hasReachedMax: hasReachedMax,
            lastDocument: refresh && docs.isEmpty ? null : lastDocument,
            totalCount: totalCount,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: LogReportStatus.failure,
            errorMessage: 'Unknown error occurred',
            totalCount: 0,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: LogReportStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> addLogReport(LogReportModel logReport) async {
    try {
      if (logReport.type == "admin") {
        return;
      }
      final response = await logRepository.addLogReport(logReport: logReport);

      if (response.startsWith('Error:')) {
        emit(
          state.copyWith(
            status: LogReportStatus.failure,
            errorMessage: response,
          ),
        );
      } else {
        // Optimistically update the list or refetch
        // We can just fetch it again
        await fetchLogReports();
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: LogReportStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
