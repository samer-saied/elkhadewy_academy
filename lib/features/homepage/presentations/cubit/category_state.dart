
import '../../data/model/category_model.dart';

abstract class CategoryState {
  const CategoryState();

  List<Object> get props => [];
}

// 1. Initial State: Before any operation has started.
class CategoryInitial extends CategoryState {}

// 2. Loading State: When fetching data from the repository.
class CategoryLoading extends CategoryState {}

// 3. Loaded State: Successfully fetched or updated data.
class CategoryLoaded extends CategoryState {
  final List<CategoryModel> items;

  const CategoryLoaded(this.items);

  @override
  List<Object> get props => [items];
}

// 4. Error State: An operation failed.
class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

// 5. Success State: A specific non-data-fetching operation (add/update/delete) succeeded.
class CategoryActionSuccess extends CategoryState {
  final String message;

  const CategoryActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}