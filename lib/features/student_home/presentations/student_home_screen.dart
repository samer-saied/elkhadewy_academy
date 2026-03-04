import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 100), // مساحة للـ Navigation Bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // buildHeader(),
            // buildSectionHeader("Continue Learning", "ACTIVE NOW"),
            // buildContinueLearningCard(),
            // buildCategoryIcons(),
            // buildSectionHeader("Your Courses", "SEE ALL"),
            // // buildCourseCards(),
            // buildSectionHeader("Upcoming Tasks", ""),
            // buildTaskItem(
            //   "12 OCT",
            //   "Portfolio Review Phase 1",
            //   "Deadline: 11:59 PM",
            // ),
            // buildTaskItem(
            //   "15 OCT",
            //   "Motion Graphics Quiz",
            //   "Module 4 Evaluation",
            // ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
