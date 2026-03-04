part of 'carousel_cubit.dart';

@immutable
sealed class CarouselState {}

final class CarouselInitial extends CarouselState {}

final class CarouselLoading extends CarouselState {}

final class CarouselLoaded extends CarouselState {
  final List<CarouselItemModel> items;
  CarouselLoaded({required this.items});
}

/// Emitted when a CRUD operation (add/update/delete) succeeds.
final class CarouselOperationSuccess extends CarouselState {
  final String message;
  CarouselOperationSuccess({required this.message});
}

/// Emitted when a CRUD operation fails.
final class CarouselOperationFailure extends CarouselState {
  final String error;
  CarouselOperationFailure({required this.error});
}

/// Emitted when a live listener updates the list.
final class CarouselListening extends CarouselState {
  final List<CarouselItemModel> items;
  CarouselListening({required this.items});
}
