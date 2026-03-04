import 'package:flutter/material.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../utils/colors.dart';
import '../../../../general/widgets/headers_widgets.dart';
import '../widgets/courses_grid_section_widget.dart';

enum FacultyLabel { bis, english, arabic, finance, other }

typedef FacultyEntry = DropdownMenuEntry<FacultyLabel>;

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final collegeId = args['collegeId'];
    final yearId = args['yearId'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        centerTitle: true,
        title: SectionHeaderSmallWidget(
          title: "Courses".tr(context),
          color: AppColors.whiteColor,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CoursesGirdSectionWidget(
                collegeId: collegeId,
                yearId: yearId.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
