import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/bloc/login_cubit.dart';
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
    final prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('last_login_phone') ?? "unknown";
    String currentUserPhone =
        GetIt.I<LoginCubit>().currentUser?.phone ?? "unknown";
    print("phone: $phone");
    print("currentUserPhone: $currentUserPhone");
    if (latestChapters.isNotEmpty &&
        !forceRefresh &&
        currentUserPhone == phone) {
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
