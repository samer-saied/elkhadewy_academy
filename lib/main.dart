import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/navigation/app_routes.dart';
import 'core/protect_screen/protect_screen.dart';
import 'features/auth/bloc/login_cubit.dart';
import 'features/auth/bloc/register_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/courses/presentations/cubit/course_cubit.dart';
import 'features/homepage/presentations/cubit/carousel_cubit.dart';
import 'features/homepage/presentations/cubit/category_cubit.dart';
import 'features/homepage/presentations/cubit/news_cubit.dart';
import 'features/sections/presentations/cubit/chapters_cubit.dart';
import 'general/presentations/cubits/locale_cubit.dart';
import 'general/presentations/cubits/navigation_cubit.dart';
import 'general/presentations/cubits/themes_cubit.dart';
import 'firebase_options.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/service_locator.dart';
import 'package:get_it/get_it.dart';
import 'services/lang/app_localizations.dart';
import 'services/themes/app_themes.dart';
import 'core/databases/cache/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Protect Screen
  ProtectScreenController.protectDataLeakageOn();

  // Initialize service locator (GetIt)
  await ServiceLocator.init();
  await CacheHelper().init();
  runApp(const MainApp());
  // runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider<ThemesCubit>(
          create: (context) => ThemesCubit()..getSavedTheme(),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => GetIt.I.get<NavigationCubit>(),
        ),
        BlocProvider<NewsCubit>(create: (context) => GetIt.I.get<NewsCubit>()),
        BlocProvider<CategoryCubit>(
          create: (context) => GetIt.I.get<CategoryCubit>(),
        ),
        BlocProvider<CourseCubit>(
          create: (context) => GetIt.I.get<CourseCubit>(),
        ),
        BlocProvider<ChaptersCubit>(
          create: (context) => GetIt.I.get<ChaptersCubit>(),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => GetIt.I.get<RegisterCubit>(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => GetIt.I.get<LoginCubit>(),
        ),
        BlocProvider<CarouselCubit>(
          create: (context) => GetIt.I.get<CarouselCubit>(),
        ),
      ],

      child: MainAppWidget(),
    );
  }
}

class MainAppWidget extends StatelessWidget {
  const MainAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, ChangeLocaleState>(
      builder: (context, localeState) {
        return BlocBuilder<ThemesCubit, ThemesState>(
          builder: (context, themeState) {
            return MaterialApp(
              locale: context.watch<LocaleCubit>().state.locale,
              //localeState.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              home: LoginScreen(),
              onGenerateRoute: appOnGenerateRoute,
              theme: AppThemes.lightTheme,
              // darkTheme: AppThemes.darkTheme,
              // themeMode: themeState is ThemesChanged
              //     ? themeState.currentTheme == ThemeType.dark
              //           ? ThemeMode.dark
              //           : ThemeMode.light
              //     : ThemeMode.system,
            );
          },
        );
      },
    );
  }
}
