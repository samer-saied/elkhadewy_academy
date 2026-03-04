import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/chapter_model.dart';
import '../../data/chapters_repository.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit(this._repository) : super(ChaptersInitial());

  final ChaptersRepository _repository;

  Future<void> fetchChapters(String courseId) async {
    emit(ChaptersLoading());
    try {
      final items = await _repository.getChaptersByCourseId(
        courseId,
        orderBy: "orderIndex",
        descending: false,
      );
      emit(ChaptersLoaded(items: items));
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> getChapterById(String courseId, String chapterId) async {
    // emit(ChaptersLoading());
    try {
      final item = await _repository.getById(courseId, chapterId);
      emit(ChaptersLoaded(items: [item]));
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  void listenToChapters(String courseId) {
    try {
      _repository.listen(
        courseId: courseId,
        onChange: (items) => emit(ChaptersListening(items: items)),
      );
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> addChapter(String courseId, Chapter chapter) async {
    emit(ChaptersLoading());
    try {
      await _repository.add(courseId, chapter);
      emit(ChaptersOperationSuccess(message: 'Chapter added'));
      await fetchChapters(courseId);
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> updateChapter(String courseId, Chapter chapter) async {
    emit(ChaptersLoading());
    try {
      await _repository.update(courseId, chapter);
      emit(ChaptersOperationSuccess(message: 'Chapter updated'));
      await fetchChapters(courseId);
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> deleteChapter(String courseId, String chapterId) async {
    emit(ChaptersLoading());
    try {
      await _repository.delete(courseId, chapterId);
      emit(ChaptersOperationSuccess(message: 'Chapter deleted'));
      await fetchChapters(courseId);
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }
}
