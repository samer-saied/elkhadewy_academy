// import 'package:flutter/material.dart';
// import 'package:hugeicons/hugeicons.dart';

// import '../../../../general/widgets/headers_widgets.dart';
// import '../../../../utils/colors.dart';
// import 'courses_grid_section_widget.dart';
// import 'courses_vertical_section_widget.dart';

// class ToggleViewWidget extends StatefulWidget {
//   const ToggleViewWidget({super.key});

//   @override
//   State<ToggleViewWidget> createState() => _ToggleViewWidgetState();
// }

// class _ToggleViewWidgetState extends State<ToggleViewWidget> {
//   List<bool> isSelectedList = [false, true];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SectionHeaderWidget(title: "Courses", action: ""),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 7.0),
//               child: ToggleButtons(
//                 focusColor: AppColors.mainColor,
//                 color: AppColors.grey,
//                 disabledColor: AppColors.whiteColor,
//                 selectedColor: Theme.brightnessOf(context) == Brightness.dark
//                     ? AppColors.whiteColor
//                     : AppColors.mainColor,
//                 borderRadius: BorderRadius.circular(14),
//                 onPressed: (index) {
//                   setState(() {
//                     isSelectedList = [false, false];
//                     isSelectedList[index] = !isSelectedList[index];
//                   });
//                 },
//                 isSelected: isSelectedList,
//                 children: [
//                   HugeIcon(icon: HugeIcons.strokeRoundedListView),
//                   HugeIcon(icon: HugeIcons.strokeRoundedGridView),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 3),

//         IndexedStack(
//           index: isSelectedList.indexOf(true),
//           clipBehavior: Clip.antiAlias,
//           children: [
//             Visibility(
//               visible: isSelectedList.indexOf(true) == 0,
//               child: CoursesVListSectionWidget(),
//             ),
//             Visibility(
//               visible: isSelectedList.indexOf(true) == 1,
//               child: CoursesGirdSectionWidget(
//                 collegeId: widget.collegeId,
//                 yearId: widget.yearId,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
