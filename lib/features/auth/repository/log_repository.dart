import '../../../core/remote/firebase_firestore_service.dart';

class LogRepository {
  final FirebaseFirestoreService _service;
  final String collectionId = 'login_reports';

  LogRepository(this._service);

  Future<String> addLogReport({
    required String name,
    required String email,
    required String password,
    required String phone,
    required bool isSuccess,
    required String result,
    required String dateTime,
  }) async {
    try {
      String id = await _service.addDocument(
        collectionId: collectionId,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'isSuccess': isSuccess,
          'result': result,
          'dateTime': dateTime,
        },
      );
      return id;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
