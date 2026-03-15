import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/remote/firebase_firestore_service.dart';
import '../../data/model/news_item_model.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsLoading());

  final FirebaseFirestoreService _service = FirebaseFirestoreService();
  List<NewsItemModel> newsItems = [];

  /// Fetch current items once (non-listening)
  Future<void> fetchNewsItems({bool forceRefresh = false}) async {
    if (newsItems.isNotEmpty && !forceRefresh) {
      emit(NewsLoaded(items: newsItems));
      return;
    }
    emit(NewsLoading());
    try {
      newsItems.clear();
      final docs = await _service.getCollection(collectionId: 'news');
      newsItems = docs
          .map(
            (doc) => NewsItemModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
      emit(NewsLoaded(items: newsItems));
    } catch (e) {
      emit(NewsOperationFailure(error: e.toString()));
    }
  }

  /// Start listening to collection changes and emit `NewsListening` updates.
  // void listenToNews({
  //   String orderByField = 'priority',
  //   bool descending = false,
  // }) {
  //   try {
  //     _service.listenToCollection(
  //       collectionId: 'news',
  //       orderByField: orderByField,
  //       descending: descending,
  //       onChange: (docs) {
  //         final items = docs
  //             .map(
  //               (doc) => NewsItemModel.fromFirestore(
  //                 doc.data() as Map<String, dynamic>,
  //                 doc.id,
  //               ),
  //             )
  //             .toList();
  //         emit(NewsListening(items: items));
  //       },
  //     );
  //   } catch (e) {
  //     emit(NewsOperationFailure(error: e.toString()));
  //   }
  // }

  Future<void> addNewsItem({required NewsItemModel news}) async {
    emit(NewsLoading());
    try {
      await _service.addDocument(
        collectionId: 'news',
        data: news.toFirestore(),
      );
      emit(NewsOperationSuccess(message: 'Item added'));
      await fetchNewsItems(forceRefresh: true);
    } catch (e) {
      emit(NewsOperationFailure(error: e.toString()));
    }
  }

  Future<void> updateNewsItem({required NewsItemModel news}) async {
    emit(NewsLoading());
    try {
      await _service.updateDocument(
        collectionId: 'news',
        documentId: news.id!,
        data: news.toFirestore(),
      );
      emit(NewsOperationSuccess(message: 'Item updated'));
      await fetchNewsItems(forceRefresh: true);
    } catch (e) {
      emit(NewsOperationFailure(error: e.toString()));
    }
  }

  Future<void> deleteNewsItem(String id) async {
    emit(NewsLoading());
    try {
      await _service.deleteDocument(collectionId: 'news', documentId: id);
      emit(NewsOperationSuccess(message: 'Item deleted'));
      await fetchNewsItems(forceRefresh: true);
    } catch (e) {
      emit(NewsOperationFailure(error: e.toString()));
    }
  }
}
