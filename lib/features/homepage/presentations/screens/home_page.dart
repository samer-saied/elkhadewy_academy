import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/courses/presentations/cubit/course_cubit.dart';
import 'package:unimind/features/homepage/presentations/cubit/news_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../../core/device_info/device_info.dart';
import '../../../../general/presentations/cubits/navigation_cubit.dart';
import '../../../../general/widgets/headers_widgets.dart';
import '../../../../utils/colors.dart';
import '../../../auth/bloc/login_cubit.dart';
import '../../../course_details/presentations/cubit/chapters_cubit.dart';
import '../widgets/carousel/carousel_widget.dart';
import '../widgets/category_horizontal_section_widget.dart';
import '../widgets/continue_learning/continue_widgets.dart';
import '../widgets/faetured_courses_section_widget.dart';
import '../widgets/divider_widget.dart';
import '../widgets/cahpters/latest_chapter_section_widget.dart';
import '../widgets/news_section_widget.dart';
import '../widgets/welcome_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceInfo().getUniqueId().then((value) {
      // print(value);
    });

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration.zero, () {
            HapticFeedback.mediumImpact();
            GetIt.I<NewsCubit>().fetchNewsItems(forceRefresh: true);
            GetIt.I<LoginCubit>().refreshUserData();
            final materials = GetIt.I.get<LoginCubit>().currentUser!.materials;
            GetIt.I.get<CourseCubit>().fetchUsersCourse(
              materials: materials,
              forceRefresh: true,
            );
            GetIt.I.get<ChaptersCubit>().latestChaptersFunc(
              userMaterials: materials,
              forceRefresh: true,
            );
          });
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // NotificationTopBarWidget(),
              Container(
                padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                decoration: BoxDecoration(
                  color: AppColors.jonquil,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                child: WelcomeUserWidget(),
              ),

              CarouselWidget(),
              // DividerWidget(),
              buildContinueLearningCard(context),
              SectionHeaderWidget(title: "Recent News".tr(context), action: ""),
              NewsSectionWidget(),

              // DividerWidget(),
              SectionHeaderWidget(
                title: "Colleges".tr(context),
                action: "VIEW ALL".tr(context),
                onTapFunc: () {
                  context.read<NavigationCubit>().updateIndex(1);
                },
              ),
              CategoryHListSectionWidget(widgetType: WidgetType.labels),

              SectionHeaderWidget(
                title: "Your Courses".tr(context),
                action: "",
              ),
              FaeturedCoursesSectionWidget(),
              DividerWidget(),

              LatestChapterSectionWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
