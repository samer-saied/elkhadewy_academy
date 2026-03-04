import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/remote/firebase_firestore_service.dart';
import '../model/category_model.dart'; // Assuming CategoryModel is in this path

class CategoryRepository {
  final FirebaseFirestoreService _service;
  final String collectionId = 'categories'; // Changed to 'categories'

  CategoryRepository(this._service);

  /// Fetches all CategoryModels from the Firestore collection.
  Future<List<CategoryModel>> getAll({
    String? orderBy,
    bool descending = false,
  }) async {
    final docs = await _service.getCollection(
      collectionId: collectionId,
      orderByField: orderBy,
      descending: descending,
    );
    // Note: CategoryModel.fromFirestore requires the snapshot and the document ID.
    final items = docs
        .map((d) => CategoryModel.fromFirestore(d, d.id))
        .toList();

    // Cache categories in SharedPreferences for quick getById lookup
    // try {
    //   final prefs = await SharedPreferences.getInstance();
    //   final List<Map<String, dynamic>> serialized = items.map((c) {
    //     final map = c.toFirestore();
    //     // ensure id is included for lookup
    //     map['id'] = c.id;
    //     return map;
    //   }).toList();
    //   await prefs.setString('categories_cache', jsonEncode(serialized));
    // } catch (_) {
    //   // caching failure should not break normal flow
    // }

    return items;
  }

  /// Listens for real-time changes to the Firestore collection.
  void listen({
    required Function(List<CategoryModel>) onChange,
    String? orderBy,
    bool descending = false,
  }) {
    _service.listenToCollection(
      collectionId: collectionId,
      orderByField: orderBy ?? "100",
      descending: descending,
      // Note: CategoryModel.fromFirestore requires the snapshot and the document ID.
      onChange: (docs) => onChange(
        docs.map((d) => CategoryModel.fromFirestore(d, d.id)).toList(),
      ),
    );
  }

  /// Fetches a single CategoryModel by its document ID.
  Future<CategoryModel> getById(String id) async {
    // First check local cache in SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('categories_cache');
      if (cached != null && cached.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cached);
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            if ((item['id']?.toString() ?? '') == id) {
              return CategoryModel.fromFirestore(item, id);
            }
          } else if (item is Map) {
            // handle cases where jsonDecode returns Map<dynamic,dynamic>
            final map = Map<String, dynamic>.from(item);
            if ((map['id']?.toString() ?? '') == id) {
              return CategoryModel.fromFirestore(map, id);
            }
          }
        }
      }
    } catch (_) {
      // ignore cache errors and fall back to network
    }

    final doc = await _service.getDocument(
      collectionId: collectionId,
      documentId: id,
    );
    // Note: CategoryModel.fromFirestore requires the snapshot and the document ID.
    return CategoryModel.fromFirestore(doc, id);
  }

  /// Adds a new CategoryModel to the Firestore collection.
  Future<void> add(CategoryModel model) async {
    await _service.addDocument(
      collectionId: collectionId,
      data: model.toFirestore(),
    );
  }

  /// Adds a new CategoryModel using a specific document ID.
  Future<void> addWithId(String id, CategoryModel model) async {
    await _service.addDocumentUsingId(
      collectionId: collectionId,
      documentId: id,
      data: model.toFirestore(),
    );
  }

  /// Updates an existing CategoryModel in the Firestore collection.
  Future<void> update(CategoryModel model) async {
    if (model.id == null)
      throw ArgumentError('Model id is required for update');
    await _service.updateDocument(
      collectionId: collectionId,
      documentId: model.id!,
      data: model.toFirestore(),
    );
  }

  /// Deletes a CategoryModel by its document ID.
  Future<void> delete(String id) async {
    await _service.deleteDocument(collectionId: collectionId, documentId: id);
  }
}
