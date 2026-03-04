import 'package:flutter/material.dart';

import '../../features/admin/manage_courses/add_course.dart';
import '../../features/admin/manage_news/add_news.dart';
import '../../features/admin/manage_courses/edit_courses.dart';
import '../../features/admin/manage_courses/manage_courses.dart';
import '../../features/admin/manage_news/edit_news.dart';
import '../../features/admin/manage_news/manage_news.dart';
import '../../features/courses/data/models/course_model.dart';
import '../../features/admin/add_chapter/add_chapter.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/contact_me/contact_me_screen.dart';
import '../../features/course_details/presentations/screens/course_details_page.dart';
import '../../features/courses/presentations/screens/courses_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/admin/admin_screen.dart';
import '../../features/homepage/data/model/news_item_model.dart';
import '../../features/profile/presentations/profile_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/single_news/single_news_page.dart';
import '../../features/student_home/presentations/student_home_screen.dart';
import '../../features/watching_report/watching_report.dart';
import '../../main_page.dart';

/// Centralized app route names.
class AppRoutes {
  static const String login = '/login';
  static const String main = '/main';
  static const String singleNews = '/SingleNewsPage';
  static const String courses = '/courses';
  static const String studentHome = '/StudentHome';
  static const String contactMe = '/contactMe';
  static const String register = '/register';
  static const String courseDetails = '/CourseDetailsPage';
  static const String settingsPage = '/SettingsPage';
  static const String adminPage = '/AdminPage';
  static const String profilePage = '/ProfilePage';
  ///// Admin
  static const String addChapter = '/AddChapterPage';
  static const String addNews = '/AddNewsPage';
  static const String manageNews = '/ManageNewsPage';
  static const String editNews = '/EditNewsPage';
  static const String addCourse = '/AddCoursePage';
  static const String manageCourse = '/ManageCoursePage';
  static const String editCourse = '/EditCoursePage';
  static const String watchingReport = '/WatchingReportPage';
}

/// Route generator used by `MaterialApp.onGenerateRoute`.
Route<dynamic>? appOnGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.login:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: settings,
      );
    case AppRoutes.main:
      return MaterialPageRoute(
        builder: (context) => const MainPage(),
        settings: settings,
      );
    case AppRoutes.singleNews:
      final newsItem = settings.arguments as NewsItemModel;
      return MaterialPageRoute(
        builder: (context) => SingleNewsPage(singleNews: newsItem),
        settings: settings,
      );
    case AppRoutes.courses:
      return MaterialPageRoute(
        builder: (context) => const CoursesPage(),
        settings: settings,
      );
    case AppRoutes.studentHome:
      return MaterialPageRoute(
        builder: (context) => const StudentHomeScreen(),
        settings: settings,
      );
    case AppRoutes.contactMe:
      return MaterialPageRoute(
        builder: (context) => const ContactMeScreen(),
        settings: settings,
      );
    case AppRoutes.register:
      return MaterialPageRoute(
        builder: (context) => const RegisterPage(),
        settings: settings,
      );

    case AppRoutes.courseDetails:
      final course = settings.arguments as CourseModel;
      return MaterialPageRoute(
        builder: (context) => CourseDetailsPage(course: course),
        settings: settings,
      );

    case AppRoutes.settingsPage:
      return MaterialPageRoute(
        builder: (context) => SettingsPage(),
        settings: settings,
      );

    case AppRoutes.profilePage:
      return MaterialPageRoute(
        builder: (context) => const ProfilePage(),
        settings: settings,
      );
    ///////////////// ADMIN /////////////////
    ///
    ///
    case AppRoutes.addChapter:
      return MaterialPageRoute(
        builder: (context) => const AddChapterPage(),
        settings: settings,
      );

    case AppRoutes.addNews:
      return MaterialPageRoute(
        builder: (context) => const AddNewsPage(),
        settings: settings,
      );

    case AppRoutes.manageNews:
      return MaterialPageRoute(
        builder: (context) => const ManageNewsPage(),
        settings: settings,
      );

    case AppRoutes.editNews:
      final newsItem = settings.arguments as NewsItemModel;
      return MaterialPageRoute(
        builder: (context) => EditNewsPage(news: newsItem),
        settings: settings,
      );

    case AppRoutes.addCourse:
      return MaterialPageRoute(
        builder: (context) => const AddCoursesPage(),
        settings: settings,
      );

    case AppRoutes.manageCourse:
      return MaterialPageRoute(
        builder: (context) => const ManageCoursesPage(),
        settings: settings,
      );

    case AppRoutes.editCourse:
      final course = settings.arguments as CourseModel;
      return MaterialPageRoute(
        builder: (context) => EditCoursesPage(courses: course),
        settings: settings,
      );

    case AppRoutes.adminPage:
      return MaterialPageRoute(
        builder: (context) => const AdminPage(),
        settings: settings,
      );

    case AppRoutes.watchingReport:
      return MaterialPageRoute(
        builder: (context) => const WatchingReportPage(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Unknown Route')),
          body: Center(child: Text('No route defined for "${settings.name}"')),
        ),
        settings: settings,
      );
  }
}
