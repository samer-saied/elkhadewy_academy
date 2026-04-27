import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/log_report_model.dart';

enum LogReportStatus { initial, loading, success, failure }

class LogReportState {
  final LogReportStatus status;
  final String errorMessage;
  final List<LogReportModel> reports;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;
  final int totalCount;

  LogReportState({
    this.status = LogReportStatus.initial,
    this.errorMessage = '',
    this.reports = const [],
    this.hasReachedMax = false,
    this.lastDocument,
    this.totalCount = 0,
  });

  LogReportState copyWith({
    LogReportStatus? status,
    String? errorMessage,
    List<LogReportModel>? reports,
    bool? hasReachedMax,
    DocumentSnapshot? lastDocument,
    int? totalCount,
  }) {
    return LogReportState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      reports: reports ?? this.reports,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocument: lastDocument ?? this.lastDocument,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
