import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/homepage/data/model/category_model.dart';
import 'package:unimind/features/homepage/presentations/cubit/category_cubit.dart';
import 'package:unimind/utils/colors.dart';

import '../../cubit/statistic_cubit.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION 1: Faculty
        buildSectionTitle('College'),
        BuildFacultyFilters(),
        const SizedBox(height: 5),

        // SECTION 2: Academic Year
        buildSectionTitle('Academic Year'),
        BuildAcademicYearFilters(),
        const SizedBox(height: 5),
      ],
    );
  }

  // // --- Sort By Custom Segmented Control ---
  // Widget _buildSortBySegmentedControl() {
  //   return Container(
  //     padding: const EdgeInsets.all(4),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFE9F0F8), // Light blue background
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: IntrinsicHeight(
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Option 1: Subjects (المواد)
  //           _buildSortOption(
  //             label: 'Courses',
  //             isSelected: _sortBySubject,
  //             onTap: () {
  //               setState(() {
  //                 _sortBySubject = true;
  //               });
  //             },
  //           ),
  //           // Option 2: Recent (التسجيل الأخير)
  //           _buildSortOption(
  //             label: "Status",
  //             isSelected: !_sortBySubject,
  //             onTap: () {
  //               setState(() {
  //                 _sortBySubject = false;
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// --- Faculty Filter Chips ---
class BuildFacultyFilters extends StatelessWidget {
  const BuildFacultyFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> faculties = GetIt.I<CategoryCubit>().categories;

    return SizedBox(
      height: 50,
      child: BlocBuilder<StatisticCubit, StatisticState>(
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: faculties.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isSelected =
                  GetIt.I<StatisticCubit>().selectedFacultyValue
                      .toUpperCase() ==
                  faculties[index].title.toUpperCase();
              return _CustomFilterChip(
                label: faculties[index].title,
                isSelected: isSelected,
                onSelected: (bool selected) {
                  GetIt.I<StatisticCubit>().changeSelectedFaculty(
                    faculties[index].title,
                  );
                },
                // Medicine chip has a specific border/shade as seen in the image
                isMedicineChip: index == 1,
              );
            },
          );
        },
      ),
    );
  }
}

// --- Academic Year Filter Chips ---
class BuildAcademicYearFilters extends StatelessWidget {
  const BuildAcademicYearFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> years = [
      'First Year',
      'Second Year',
      'Third Year',
      'Fourth Year',
    ];

    return SizedBox(
      height: 50,
      child: BlocBuilder<StatisticCubit, StatisticState>(
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: years.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final isSelected =
                  GetIt.I<StatisticCubit>().selectedAcademicYear == index;
              return _CustomFilterChip(
                label: years[index],
                isSelected: isSelected,
                onSelected: (bool selected) {
                  GetIt.I<StatisticCubit>().changeSelectedAcademicYear(index);
                },
              );
            },
          );
        },
      ),
    );
  }
}

// --- Custom reusable FilterChip widget ---
class _CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final bool isMedicineChip; // Optional specific styling for Medicine

  const _CustomFilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.isMedicineChip = false,
  });

  @override
  Widget build(BuildContext context) {
    // Customizing the default FilterChip
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,

      // Main branding colors based on image
      selectedColor: AppColors.jonquil, // Golden-brown selected color
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        // Text color logic: white on selected, grey on unselected
        color: isSelected ? AppColors.whiteColor : AppColors.darkGrey,
      ),
      elevation: 0,
      pressElevation: 0,
      backgroundColor: AppColors.whiteColor,

      // Shape and padding customization
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // If it's the Medicine chip (index 1), give it a soft border
        side: BorderSide(
          color: AppColors.jonquilLight.withAlpha(30),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}

// --- Common Title Builder ---
Widget buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.raisinBlack, // Text grey
          ),
        ),
      ],
    ),
  );
}
