import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  Future<List<QueryDocumentSnapshot>> getCollectionsByField({
    required String collectionId,
    String? filterField,
    dynamic filterValue,
    dynamic isGreaterThanOrEqualTo,
    dynamic isLessThan,
    String? filterField2,
    dynamic filterValue2,
    int? limit,
    String? orderByField,
    bool isAscending = true,
  }) async {
    Query<Object?> query = FirebaseFirestore.instance.collection(collectionId);

    if (filterField != null) {
      if (filterValue != null) {
        query = query.where(filterField, isEqualTo: filterValue);
      }
      if (isGreaterThanOrEqualTo != null) {
        query = query.where(
          filterField,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        );
      }
      if (isLessThan != null) {
        query = query.where(filterField, isLessThan: isLessThan);
      }
    }

    if (filterField2 != null && filterValue2 != null) {
      query = query.where(filterField2, isEqualTo: filterValue2);
    }

    if (orderByField != null) {
      query = query.orderBy(orderByField, descending: !isAscending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final querySnapshot = await query.get();

    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getCollectionsByList({
    required String collectionId,
    required String filterField,
    required dynamic filterValue,
  }) async {
    Query<Object?> query = FirebaseFirestore.instance.collection(collectionId);

    query = query.where(filterField, arrayContains: filterValue);

    final querySnapshot = await query.get();

    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getCollections4LastWatchingReport({
    required String collectionId,
    String? filterField,
    dynamic filterValue,
    String? filterField2,
    dynamic filterValue2,
    int? limit,
    String? orderByField,
    bool isAscending = true,
  }) async {
    Query<Object?> query = FirebaseFirestore.instance.collection(collectionId);

    if (filterField != null) {
      if (filterValue != null) {
        query = query.where(filterField, isEqualTo: filterValue);
      }
      if (filterField2 != null && filterValue2 != null) {
        query = query.where(filterField2, isEqualTo: filterValue2);
      }

      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: !isAscending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      // print('filterField: ${querySnapshot.docs}');

      return querySnapshot.docs;
    }
    return [];
  }

  Future<List<QueryDocumentSnapshot>> getCollection({
    required String collectionId,
    String? orderByField,
    bool descending = false,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    if (orderByField != null) {
      final querySnapshot = await reference
          .orderBy(orderByField, descending: descending)
          .get();
      return querySnapshot.docs;
    } else {
      final querySnapshot = await reference.get();
      return querySnapshot.docs;
    }
  }

  Future<List<QueryDocumentSnapshot>> getSubCollection({
    required String collectionId,
    required String documentId,
    required String subCollectionId,
    String? orderByField,
    bool descending = false,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance
        .collection(collectionId)
        .doc(documentId)
        .collection(subCollectionId);
    if (orderByField != null) {
      final querySnapshot = await reference
          .orderBy(orderByField, descending: descending)
          .get();
      return querySnapshot.docs;
    } else {
      final querySnapshot = await reference.get();
      return querySnapshot.docs;
    }
  }

  void listenToCollection({
    required Function(List<QueryDocumentSnapshot>) onChange,
    required String collectionId,
    required String orderByField,
    bool descending = false,
  }) {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    reference
        .orderBy(orderByField, descending: descending)
        .snapshots()
        .listen((event) => onChange(event.docs));
  }

  void listenToSubCollection({
    required Function(List<QueryDocumentSnapshot>) onChange,
    required String collectionId,
    required String documentId,
    required String subCollectionId,
    required String orderByField,
    bool descending = false,
  }) {
    final CollectionReference reference = FirebaseFirestore.instance
        .collection(collectionId)
        .doc(documentId)
        .collection(subCollectionId);
    reference
        .orderBy(orderByField, descending: descending)
        .snapshots()
        .listen((event) => onChange(event.docs));
  }

  Future<DocumentSnapshot> getDocument({
    required String collectionId,
    required String documentId,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    final DocumentSnapshot querySnapshot = await reference
        .doc(documentId)
        .get();
    return querySnapshot;
  }

  Future<QuerySnapshot> getDocuments({
    required String collectionId,
    required Map<String, dynamic> where,
  }) async {
    Query query = FirebaseFirestore.instance.collection(collectionId);
    where.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });
    return await query.get();
  }

  Future<DocumentSnapshot> getSubDocument({
    required String collectionId,
    required String documentId,
    required String subCollectionId,
    required String subDocumentId,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    final DocumentSnapshot querySnapshot = await reference
        .doc(documentId)
        .collection(subCollectionId)
        .doc(subDocumentId)
        .get();
    return querySnapshot;
  }

  Future<void> updateDocument({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    await reference.doc(documentId).update(data);
  }

  Future<void> updateSubCollectionDocument({
    required String collectionId,
    required String subCollectionId,
    required String documentId,
    required String subDocumentId,
    required Map<String, dynamic> data,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    await reference
        .doc(documentId)
        .collection(subCollectionId)
        .doc(subDocumentId)
        .update(data);
  }

  Future<void> deleteDocument({
    required String collectionId,
    required String documentId,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    await reference.doc(documentId).delete();
  }

  Future<void> deleteSubCollectionDocument({
    required String collectionId,
    required String documentId,
    required String subDocumentId,
    required String subCollectionId,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    await reference
        .doc(documentId)
        .collection(subCollectionId)
        .doc(subDocumentId)
        .delete();
  }

  Future<String> addDocument({
    required String collectionId,
    required Map<String, dynamic> data,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    DocumentReference result = await reference.add(data);
    return result.id;
  }

  Future<void> addDocumentUsingId({
    required String collectionId,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    await reference.doc(documentId).set(data);
  }

  Future<void> addSubDocumentUsingId({
    required String collectionId,
    required String subCollectionId,
    required String documentId,
    required String subDocumentId,
    required Map<String, dynamic> data,
  }) async {
    final CollectionReference reference = FirebaseFirestore.instance.collection(
      collectionId,
    );
    await reference
        .doc(documentId)
        .collection(subCollectionId)
        .doc(subDocumentId)
        .set(data);
  }

  Future<int> getDocumentsCount({
    required String collectionId,
    String? field,
    dynamic value,
    String? field2,
    dynamic value2,
  }) async {
    Query<Map<String, dynamic>> reference = FirebaseFirestore.instance
        .collection(collectionId)
        .where(field ?? "", isEqualTo: value);

    if (field2 != null && value2 != null) {
      reference = reference.where(field2, isEqualTo: value2);
    }
    final AggregateQuerySnapshot count = await reference.count().get();
    return count.count ?? 0;
  }

  Future<int> getDocumentsCountByList({
    required String collectionId,
    String? field,
    dynamic value,
    String? field2,
    dynamic value2,
  }) async {
    try {
      Query<Map<String, dynamic>> reference = FirebaseFirestore.instance
          .collection(collectionId)
          // .where(field ?? "", isEqualTo: value)
          .where(field2 ?? "", arrayContains: value2)
          .where(field ?? "", isEqualTo: value);

      final AggregateQuerySnapshot count = await reference.count().get();

      return count.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
