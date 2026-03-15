import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/course_model.dart';
import '../../data/repositories/courses_repository.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit(this._repository) : super(CourseLoading());

  final CoursesRepository _repository;

  List<CourseModel> userCourses = [];
  List<CourseModel> allCourses = [];

  Future<void> fetchCourseItems({bool forceRefresh = false}) async {
    if (allCourses.isNotEmpty && !forceRefresh) {
      emit(CourseLoaded(items: allCourses));
      return;
    }
    emit(CourseLoading());
    allCourses.clear();
    try {
      final items = await _repository.getAll();
      allCourses.addAll(items);
      emit(CourseLoaded(items: allCourses));
    } catch (e) {
      emit(CourseOperationFailure(error: e.toString()));
    }
  }

  /// Fetch specific courses once (non-listening)
  Future<void> fetchSpecificCourses(String collegeId, String yearId) async {
    emit(CourseLoading());
    try {
      final items = await _repository.getSpecificCourses(collegeId, yearId);
      emit(CourseLoaded(items: items));
    } catch (e) {
      emit(CourseOperationFailure(error: e.toString()));
    }
  }

  Future<void> fetchUsersCourse({
    required List<String> materials,
    bool forceRefresh = false,
  }) async {
    emit(CourseLoading());
    if (userCourses.isNotEmpty && !forceRefresh) {
      emit(CourseLoaded(items: userCourses));
      return;
    }
    try {
      userCourses.clear();
      for (String materialId in materials) {
        final item = await _repository.getById(materialId);
        if (item != null) {
          userCourses.add(item);
        }
      }
      emit(CourseLoaded(items: userCourses));
    } catch (e) {
      emit(CourseOperationFailure(error: e.toString()));
    }
  }

  Future<void> addCourseItem(CourseModel item) async {
    emit(CourseLoading());
    try {
      await _repository.add(item);
      emit(CourseOperationSuccess(message: 'Item added'));
      await fetchCourseItems(forceRefresh: true);
    } catch (e) {
      emit(CourseOperationFailure(error: e.toString()));
    }
  }

  Future<void> updateCourseItem(CourseModel item) async {
    emit(CourseLoading());
    try {
      await _repository.update(item);
      emit(CourseOperationSuccess(message: 'Item updated'));
      await fetchCourseItems(forceRefresh: true);
    } catch (e) {
      emit(CourseOperationFailure(error: e.toString()));
    }
  }

  Future<void> deleteCourseItem(String id) async {
    emit(CourseLoading());
    try {
      await _repository.delete(id);
      emit(CourseOperationSuccess(message: 'Item deleted'));
      await fetchCourseItems(forceRefresh: true);
    } catch (e) {
      emit(CourseOperationFailure(error: e.toString()));
    }
  }
}
