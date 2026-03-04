part of 'news_cubit.dart';


@immutable
sealed class NewsState {}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState {
  final List<NewsItemModel> items;
  NewsLoaded({required this.items});
}

/// Emitted when a CRUD operation (add/update/delete) succeeds.
final class NewsOperationSuccess extends NewsState {
  final String message;
  NewsOperationSuccess({required this.message});
}

/// Emitted when a CRUD operation fails.
final class NewsOperationFailure extends NewsState {
  final String error;
  NewsOperationFailure({required this.error});
}

/// Emitted when a live listener updates the list.
final class NewsListening extends NewsState {
  final List<NewsItemModel> items;
  NewsListening({required this.items});
}
