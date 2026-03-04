import '../../../../core/remote/firebase_firestore_service.dart';
import '../models/course_model.dart';

class CoursesRepository {
  final FirebaseFirestoreService _service;
  final String collectionId = 'courses';

  CoursesRepository(this._service);

  Future<List<CourseModel>> getAll({
    String? orderBy,
    bool descending = false,
  }) async {
    final docs = await _service.getCollection(
      collectionId: collectionId,
      orderByField: orderBy,
      descending: descending,
    );
    return docs.map((d) => CourseModel.fromFirestore(d)).toList();
  }

  Future<List<CourseModel>> getSpecificCourses(
    String collegeId,
    String yearId,
  ) async {
    if (yearId == "All") {
      final docs = await _service.getCollectionsByField(
        collectionId: collectionId,
        filterField: 'collegeId',
        filterValue: collegeId,
      );
      return docs.map((d) => CourseModel.fromFirestore(d)).toList();
    }
    final docs = await _service.getCollectionsByField(
      collectionId: collectionId,
      filterField: 'collegeId',
      filterValue: collegeId,
      filterField2: 'yearId',
      filterValue2: yearId,
    );
    return docs.map((d) => CourseModel.fromFirestore(d)).toList();
  }

  void listen({
    required Function(List<CourseModel>) onChange,
    String orderBy = 'priority',
    bool descending = false,
  }) {
    _service.listenToCollection(
      collectionId: collectionId,
      orderByField: orderBy,
      descending: descending,
      onChange: (docs) =>
          onChange(docs.map((d) => CourseModel.fromFirestore(d)).toList()),
    );
  }

  Future<CourseModel> getById(String id) async {
    final doc = await _service.getDocument(
      collectionId: collectionId,
      documentId: id,
    );
    return CourseModel.fromFirestore(doc);
  }

  Future<void> add(CourseModel model) async {
    await _service.addDocument(
      collectionId: collectionId,
      data: model.toFirestore(),
    );
  }

  Future<void> addWithId(String id, CourseModel model) async {
    await _service.addDocumentUsingId(
      collectionId: collectionId,
      documentId: id,
      data: model.toFirestore(),
    );
  }

  Future<void> update(CourseModel model) async {
    if (model.id == null)
      throw ArgumentError('Model id is required for update');
    await _service.updateDocument(
      collectionId: collectionId,
      documentId: model.id!,
      data: model.toFirestore(),
    );
  }

  Future<void> delete(String id) async {
    await _service.deleteDocument(collectionId: collectionId, documentId: id);
  }
}
