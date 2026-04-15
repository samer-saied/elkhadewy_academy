import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../utils/colors.dart';
import '../../homepage/presentations/cubit/category_cubit.dart';
import '../../homepage/presentations/cubit/category_state.dart';
import '../domain/entities.dart';
import 'widgets.dart';

class SelectPathScreen extends StatefulWidget {
  const SelectPathScreen({super.key});

  @override
  State<SelectPathScreen> createState() => _SelectPathScreenState();
}

class _SelectPathScreenState extends State<SelectPathScreen> {
  // Mock Data (In a real app, this comes from a Bloc/Provider)
  String? _selectedCollegeId; // Default Engineering selected
  int _selectedYearId = 1; // Default 1st Year selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Select your path".tr(context),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.jonquil,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              "Personalize your learning experience".tr(context),
              style: AppTextStyles.subHeading,
            ),
            const SizedBox(height: 15),

            // Section 1: College Selection
            _buildSectionHeader(
              "Choose your College".tr(context),
              "STEP 1 OF 2".tr(context),
            ),
            const SizedBox(height: 15),
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  final categories = state.items;
                  return Builder(
                    builder: (context) {
                      final orientation = MediaQuery.of(context).orientation;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: orientation == Orientation.portrait
                              ? 2
                              : 4,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final college = categories[index];

                          return CollegeCard(
                            college: college,
                            isSelected: _selectedCollegeId == college.id,
                            onTap: () =>
                                setState(() => _selectedCollegeId = college.id),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: LinearProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),

            // Section 2: Year Selection
            _buildSectionHeader(
              "Select Academic Year".tr(context),
              "STEP 2 OF 2".tr(context),
            ),
            const SizedBox(height: 15),
            // ACadimic Year
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: years.map((year) {
                return YearChip(
                  label: year.label,
                  isSelected: _selectedYearId == year.id,
                  onTap: () => setState(() => _selectedYearId = year.id),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Main Action Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedCollegeId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please select a college".tr(context)),
                        behavior: SnackBarBehavior.floating,
                        dismissDirection: DismissDirection.up,
                        backgroundColor: AppColors.redWood,
                      ),
                    );
                    return;
                  }
                  // Navigate to next screen
                  Navigator.pushNamed(
                    context,
                    AppRoutes.courses,
                    arguments: {
                      "collegeId": _selectedCollegeId,
                      "yearId": _selectedYearId,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.jonquil,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Show My Courses".tr(context),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Disclaimer Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "By proceeding, you'll see curated courses specifically for your selection."
                    .tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 30), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  ////////////////// Title widget of gridview "Choose you collage" //////////////////
  Widget _buildSectionHeader(String title, String step) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.jonquil,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            step,
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
