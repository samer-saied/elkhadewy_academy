import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/remote/firebase_firestore_service.dart';
import 'chapter_model.dart';

class ChaptersRepository {
  final FirebaseFirestoreService _service;
  final String collectionId =
      'chapters'; // chapters stored as subcollection under course document
  final String subCollectionId = 'courseId';
  final Map<String, Chapter> _cache =
      {}; // simple in-memory cache keyed by 'courseId/chapterId'

  ChaptersRepository(this._service);

  Future<List<Chapter>> getAll(
    String courseId, {
    String? orderBy,
    bool descending = false,
  }) async {
    final docs = await _service.getCollection(
      collectionId: collectionId,
      orderByField: orderBy,
      descending: descending,
    );
    return docs.map((d) => Chapter.fromFirestore(d)).toList();
  }

  Future<List<Chapter>> getChaptersByCourseId(
    String courseId, {
    String? orderBy,
    bool descending = false,
  }) async {
    final docs = await _service.getCollectionsByField(
      collectionId: collectionId,
      filterField: subCollectionId,
      filterValue: courseId,
    );
    return docs.map((d) {
      Chapter chapterData = Chapter.fromFirestore(d);
      return chapterData;
    }).toList();
  }

  // /// Return a cached chapter if available, otherwise null.
  // Chapter? getCachedChapter(String courseId, String chapterId) {
  //   final key = '\$courseId/\$chapterId';
  //   return _cache[key];
  // }

  void listen({
    required String courseId,
    required Function(List<Chapter>) onChange,
    String orderBy = 'orderIndex',
    bool descending = false,
  }) {
    _service.listenToSubCollection(
      collectionId: collectionId,
      documentId: courseId,
      subCollectionId: subCollectionId,
      orderByField: orderBy,
      descending: descending,
      onChange: (docs) =>
          onChange(docs.map((d) => Chapter.fromFirestore(d)).toList()),
    );
  }

  Future<Chapter> getById(String courseId, String categoryId) async {
    final key = '\$courseId/\$chapterId';
    final cached = _cache[key];
    if (cached != null) return cached;

    final doc = await _service.getSubDocument(
      collectionId: collectionId,
      documentId: courseId,
      subCollectionId: subCollectionId,
      subDocumentId: categoryId,
    );
    final chapter = Chapter.fromFirestore(doc);
    _cache[key] = chapter;
    return chapter;
  }

  Future<void> add(String courseId, Chapter chapter) async {
    await _service.addSubDocumentUsingId(
      collectionId: collectionId,
      subCollectionId: subCollectionId,
      documentId: courseId,
      subDocumentId:
          chapter.id ??
          FirebaseFirestore.instance.collection(collectionId).doc().id,
      data: chapter.toFirestore(),
    );
  }

  Future<void> update(String courseId, Chapter chapter) async {
    if (chapter.id == null) {
      throw ArgumentError('Chapter id required for update');
    }
    await _service.updateSubCollectionDocument(
      collectionId: collectionId,
      documentId: courseId,
      subCollectionId: subCollectionId,
      subDocumentId: chapter.id!,
      data: chapter.toFirestore(),
    );
    // invalidate cache for this chapter
    final key = '\$courseId/\$chapter.id';
    _cache.remove(key);
  }

  Future<void> delete(String courseId, String chapterId) async {
    await _service.deleteSubCollectionDocument(
      collectionId: collectionId,
      documentId: courseId,
      subCollectionId: subCollectionId,
      subDocumentId: chapterId,
    );
    _cache.remove('\$courseId/\$chapterId');
  }
}
