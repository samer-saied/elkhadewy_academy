import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/device_info/device_info.dart';
import '../../../core/remote/firebase_firestore_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseFirestoreService _service;
  final String collectionId = 'users';

  AuthRepository(this._service);

  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String faculty,
    required String studyYear,
  }) async {
    try {
      QuerySnapshot snapshot = await _service.getDocuments(
        collectionId: collectionId,
        where: {'phone': phone},
      );
      if (snapshot.docs.isNotEmpty) {
        return 'Error: This phone number is already registered';
      }
      String deviceInfo = await DeviceInfo().getUniqueId();
      String id = await _service.addDocument(
        collectionId: collectionId,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'faculty': faculty,
          'studyYear': studyYear,
          'status': 'active',
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
          'deviceId': deviceInfo,
        },
      );
      return id;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<Object> loginWithDeviceId({
    required String phone,
    required String password,
  }) async {
    try {
      String deviceInfo = await DeviceInfo().getUniqueId();

      QuerySnapshot snapshot = await _service.getDocuments(
        collectionId: collectionId,
        where: {'phone': phone, 'password': password},
      );

      if (snapshot.docs.isNotEmpty) {
        UserModel user = UserModel.fromFirestore(snapshot.docs.first);
        if (user.status != 'active') {
          return 'Error: Your account is not active yet';
        }
        if (user.deviceId != deviceInfo) {
          if (user.refreshToken == true) {
            await _service.updateDocument(
              collectionId: collectionId,
              documentId: snapshot.docs.first.id,
              data: {'deviceId': deviceInfo, 'refreshToken': false},
            );
            return user;
          }
          return 'Error: Your device SERIAL has been changed!';
        }
        return user;
      } else {
        return 'Error: Invalid phone number or password';
      }
    } catch (e) {
      return 'Error: Something went wrong';
    }
  }
}
