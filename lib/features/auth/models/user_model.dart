import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String faculty;
  final String studyYear;
  final String role;
  final List<String> materials;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final String deviceId;
  final String status;
  final bool refreshToken;
  final bool statusEnableHeadset;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.faculty,
    required this.studyYear,
    required this.role,
    required this.materials,
    required this.createdAt,
    this.updatedAt,
    required this.deviceId,
    required this.status,
    this.refreshToken = false,
    this.statusEnableHeadset = true,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    List<String> materials = [];
    if (data != null && data['materials'] != null) {
      materials = data['materials'].cast<String>();
    }

    return UserModel(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      phone: doc['phone'],
      password: doc['password'],
      faculty: doc['faculty'],
      studyYear: doc['studyYear'],
      role: doc['role'],
      materials: materials,
      createdAt: doc['createdAt'],
      updatedAt: data != null && data.containsKey('updatedAt')
          ? doc['updatedAt']
          : null,
      deviceId: doc['deviceId'],
      status: doc['status'],
      refreshToken: data != null && data.containsKey('refreshToken')
          ? doc['refreshToken']
          : false,
      statusEnableHeadset:
          data != null && data.containsKey('statusEnableHeadset')
          ? doc['statusEnableHeadset']
          : true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'faculty': faculty,
      'studyYear': studyYear,
      'role': role,
      'materials': materials,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deviceId': deviceId,
      'status': status,
      'refreshToken': refreshToken,
      'statusEnableHeadset': statusEnableHeadset,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? faculty,
    String? studyYear,
    String? role,
    List<String>? materials,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? deviceId,
    String? status,
    bool? refreshToken,
    bool? statusEnableHeadset,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      faculty: faculty ?? this.faculty,
      studyYear: studyYear ?? this.studyYear,
      role: role ?? this.role,
      materials: materials ?? this.materials,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      refreshToken: refreshToken ?? this.refreshToken,
      statusEnableHeadset: statusEnableHeadset ?? this.statusEnableHeadset,
    );
  }
}
