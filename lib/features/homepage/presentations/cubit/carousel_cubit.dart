import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/carousel_item_model.dart';
import '../../data/repository/carousel_repository.dart';

part 'carousel_state.dart';

class CarouselCubit extends Cubit<CarouselState> {
  final CarouselRepository _repository;
  CarouselCubit(this._repository) : super(CarouselInitial());

  /// Fetch current items once (non-listening)
  Future<void> fetchCarouselItems() async {
    emit(CarouselLoading());
    try {
      final items = await _repository.getAll();
      emit(CarouselLoaded(items: items));
    } catch (e) {
      emit(CarouselOperationFailure(error: e.toString()));
    }
  }

  Future<void> addCarouselItem(CarouselItemModel item) async {
    emit(CarouselLoading());
    try {
      await _repository.add(item);
      emit(CarouselOperationSuccess(message: 'Item added'));
      await fetchCarouselItems();
    } catch (e) {
      emit(CarouselOperationFailure(error: e.toString()));
    }
  }

  Future<void> updateCarouselItem(CarouselItemModel item) async {
    emit(CarouselLoading());
    try {
      await _repository.update(item);
      emit(CarouselOperationSuccess(message: 'Item updated'));
      await fetchCarouselItems();
    } catch (e) {
      emit(CarouselOperationFailure(error: e.toString()));
    }
  }

  Future<void> deleteCarouselItem(String id) async {
    emit(CarouselLoading());
    try {
      await _repository.delete(id);
      emit(CarouselOperationSuccess(message: 'Item deleted'));
      await fetchCarouselItems();
    } catch (e) {
      emit(CarouselOperationFailure(error: e.toString()));
    }
  }
}
