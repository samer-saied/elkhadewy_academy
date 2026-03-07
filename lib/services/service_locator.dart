import 'package:get_it/get_it.dart';

import '../core/remote/firebase_firestore_service.dart';
import '../features/admin/users/cubit/statistic_cubit.dart';
import '../features/auth/bloc/login_cubit.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/auth/bloc/register_cubit.dart';
import '../features/course_details/data/chapters_repository.dart';
import '../features/course_details/presentations/cubit/chapters_cubit.dart';
import '../features/course_details/presentations/cubit/request_show_course_cubit.dart';
import '../features/courses/data/repositories/courses_repository.dart';
import '../features/courses/presentations/cubit/course_cubit.dart';
import '../features/homepage/data/repository/category_repository.dart';
import '../features/homepage/presentations/cubit/category_cubit.dart';
import '../features/homepage/presentations/cubit/news_cubit.dart';
import '../features/watching_report/data/cubit/watching_report_cubit.dart';
import '../general/presentations/cubits/locale_cubit.dart';
import '../general/presentations/cubits/navigation_cubit.dart';
import '../general/presentations/cubits/themes_cubit.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> init() async {
    // Register low-level services
    getIt.registerLazySingleton<FirebaseFirestoreService>(
      () => FirebaseFirestoreService(),
    );

    ///////////////////   Repositories  ///////////////////
    getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepository(getIt<FirebaseFirestoreService>()),
    );
    getIt.registerLazySingleton<CoursesRepository>(
      () => CoursesRepository(getIt<FirebaseFirestoreService>()),
    );
    getIt.registerLazySingleton<ChaptersRepository>(
      () => ChaptersRepository(getIt<FirebaseFirestoreService>()),
    );
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<FirebaseFirestoreService>()),
    );
    ///////////////////   CUBITS    ///////////////////////////
    getIt.registerLazySingleton<NavigationCubit>(() => NavigationCubit());
    getIt.registerLazySingleton<RegisterCubit>(
      () => RegisterCubit(getIt<AuthRepository>()),
    );

    getIt.registerLazySingleton<LoginCubit>(
      () => LoginCubit(getIt<AuthRepository>()),
    );

    getIt.registerLazySingleton<CategoryCubit>(
      () => CategoryCubit(getIt<CategoryRepository>()),
    );
    getIt.registerLazySingleton<CourseCubit>(
      () => CourseCubit(getIt<CoursesRepository>()),
    );
    getIt.registerLazySingleton<ChaptersCubit>(
      () => ChaptersCubit(getIt<ChaptersRepository>()),
    );
    getIt.registerLazySingleton<WatchingReportCubit>(
      () => WatchingReportCubit(getIt<FirebaseFirestoreService>()),
    );
    getIt.registerLazySingleton<StatisticCubit>(
      () => StatisticCubit(getIt<FirebaseFirestoreService>()),
    );
    getIt.registerLazySingleton<RequestShowCourseCubit>(
      () => RequestShowCourseCubit(getIt<FirebaseFirestoreService>()),
    );
    getIt.registerLazySingleton<NewsCubit>(() => NewsCubit());
    getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
    getIt.registerLazySingleton<ThemesCubit>(() => ThemesCubit());
  }
}
