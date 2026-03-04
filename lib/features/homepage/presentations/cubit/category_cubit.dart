import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../data/model/category_model.dart';
import '../../data/repository/category_repository.dart';
import 'category_state.dart';

// --- Category Cubit Implementation ---
class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial());

  // 1. Fetch Items (One-time fetch)
  List<CategoryModel> categories = [];

  Future<void> fetchItems() async {
    emit(CategoryLoading());
    try {
      if (categories.isNotEmpty) {
        emit(CategoryLoaded(categories));
      } else {
        categories = await _repository.getAll();
        emit(CategoryLoaded(categories));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  String getCategoryById({required String id}) {
    return categories.firstWhere((e) => e.id == id).title;
  }

  //   // 3. Add Item
  //   Future<void> addItem(CategoryModel category) async {
  //     try {
  //       await _repository.addCategory(category);
  //       // If listening is active, the stream will update the state.
  //       // If not listening, you might manually fetch or update the list here.
  //       emit(const CategoryActionSuccess("Category added successfully!"));
  //     } catch (e) {
  //       emit(CategoryError("Failed to add category: ${e.toString()}"));
  //     }
  //   }

  //   // 4. Update Item
  //   Future<void> updateItem(CategoryModel category) async {
  //     if (category.id == null) {
  //       return emit(const CategoryError("Cannot update category without an ID."));
  //     }
  //     try {
  //       await _repository.updateCategory(category);
  //       // Stream update handles the state change
  //       emit(const CategoryActionSuccess("Category updated successfully!"));
  //     } catch (e) {
  //       emit(CategoryError("Failed to update category: ${e.toString()}"));
  //     }
  //   }

  //   // 5. Delete Item
  //   Future<void> deleteItem(String id) async {
  //     try {
  //       await _repository.deleteCategory(id);
  //       // Stream update handles the state change
  //       emit(const CategoryActionSuccess("Category deleted successfully!"));
  //     } catch (e) {
  //       emit(CategoryError("Failed to delete category: ${e.toString()}"));
  //     }
  //   }

  //   @override
  //   Future<void> close() {
  //     _itemsSubscription?.cancel();
  //     return super.close();
  //   }
  // }
}
