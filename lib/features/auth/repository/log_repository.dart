import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/remote/firebase_firestore_service.dart';
import '../models/log_report_model.dart';

class LogRepository {
  final FirebaseFirestoreService _service;
  final String collectionId = 'login_reports';

  LogRepository(this._service);

  Future<String> addLogReport({required LogReportModel logReport}) async {
    try {
      String id = await _service.addDocument(
        collectionId: collectionId,
        data: logReport.toJson(),
      );
      return id;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<dynamic> getLogReports({
    DocumentSnapshot? startAfterDocument,
    int limit = 10,
  }) async {
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 2));
      final snapshot = await _service.getCollectionsByField(
        collectionId: collectionId,
        filterField: 'dateTime',
        isGreaterThanOrEqualTo: startOfToday.toIso8601String(),
        orderByField: 'dateTime',
        isAscending: false,
        startAfterDocument: startAfterDocument,
        limit: limit,
      );
      if (snapshot is String) {
        return snapshot;
      }
      return snapshot;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<int> getLogReportsCount() async {
    try {
      final now = DateTime.now();
      final startOfToday = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 2));
      int count = await _service.getDocumentsCountWithFilter(
        collectionId: collectionId,
        filterField: 'dateTime',
        isGreaterThanOrEqualTo: startOfToday.toIso8601String(),
      );
      if (count > 0) {
        return count;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
