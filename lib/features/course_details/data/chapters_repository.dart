import '../../../core/remote/firebase_firestore_service.dart';
import 'chapter_model.dart';

class ChaptersRepository {
  final FirebaseFirestoreService _service;
  final String collectionID = 'chapters';

  ChaptersRepository(this._service);

  Future<List<Chapter>> getCourseChapters(String courseId) async {
    final docs = await _service.getCollectionsByField(
      collectionId: collectionID,
      filterField: 'courseId',
      filterValue: courseId,
      isAscending: true,
      orderByField: 'createdAt',
    );
    return docs.map((d) => Chapter.fromFirestore(d)).toList();
  }

  Future<Chapter?> getChapterById({required String chapterId}) async {
    final doc = await _service.getDocument(
      collectionId: collectionID,
      documentId: chapterId,
    );
    if (!doc.exists) return null;
    Chapter chapter = Chapter.fromFirestore(doc);
    return chapter;
  }

  Future<List<Chapter>> getLatestChapters({
    required List<String> userMaterials,
  }) async {
    List<Chapter> chapters = [];
    for (var materialId in userMaterials) {
      final docs = await _service.getCollectionsByField(
        collectionId: collectionID,
        filterField: 'courseId',
        filterValue: materialId,
        filterField2: 'createdAt',
        filterValue2: DateTime.now().subtract(Duration(days: 7)),
        isAscending: false,
        orderByField: 'createdAt',
        limit: 1,
      );
      chapters.addAll(docs.map((d) => Chapter.fromFirestore(d)).toList());
    }
    return chapters;
  }

  addChapter(Chapter chapter) async {
    await _service.addDocument(
      collectionId: collectionID,
      data: chapter.toFirestore(),
    );
  }

  updateChapter(Chapter chapter) async {
    await _service.updateDocument(
      collectionId: collectionID,
      documentId: chapter.id!,
      data: chapter.toFirestore(),
    );
  }

  deleteChapter(String chapterId) async {
    await _service.deleteDocument(
      collectionId: collectionID,
      documentId: chapterId,
    );
  }
}
