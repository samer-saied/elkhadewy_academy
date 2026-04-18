import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/chapter_model.dart';
import '../../data/chapters_repository.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit(this._repository) : super(ChaptersInitial());

  final ChaptersRepository _repository;
  final List<Chapter> latestChapters = [];
  late Chapter watchedChapters;

  Future<void> fetchChapters(String courseId) async {
    emit(ChaptersLoading());

    try {
      final List<Chapter> items = await _repository.getCourseChapters(courseId);
      emit(ChaptersLoaded(items: items));
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<Chapter?> fetchlastWatchingChapter({required String chapterId}) async {
    Chapter? chapter = await _repository.getChapterById(chapterId: chapterId);
    return chapter;
  }

  Future<void> latestChaptersFunc({
    required List<String> userMaterials,
    bool forceRefresh = false,
  }) async {
    if (latestChapters.isNotEmpty && !forceRefresh) {
      emit(ChaptersLoaded(items: latestChapters));
      return;
    }
    emit(ChaptersLoading());
    try {
      final List<Chapter> items = await _repository.getLatestChapters(
        userMaterials: userMaterials,
      );
      latestChapters.clear();
      latestChapters.addAll(items);
      latestChapters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(ChaptersLoaded(items: latestChapters));
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> addChapter(String courseId, Chapter chapter) async {
    emit(ChaptersLoading());
    try {
      await _repository.addChapter(chapter);
      emit(ChaptersOperationSuccess(message: 'Chapter added'));
      await fetchChapters(courseId);
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> updateChapter(String courseId, Chapter chapter) async {
    emit(ChaptersLoading());
    try {
      await _repository.updateChapter(chapter);
      emit(ChaptersOperationSuccess(message: 'Chapter updated'));
      await fetchChapters(courseId);
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }

  Future<void> deleteChapter(String courseId, String chapterId) async {
    emit(ChaptersLoading());
    try {
      await _repository.deleteChapter(chapterId);
      emit(ChaptersOperationSuccess(message: 'Chapter deleted'));
      await fetchChapters(courseId);
    } catch (e) {
      emit(ChaptersFailure(error: e.toString()));
    }
  }
}
