// // 1. الجزء العلوي (الترحيب والبحث)
// import 'package:flutter/material.dart';

// import '../../../utils/colors.dart';

// Widget buildHeader() {
//   return Container(
//     padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xFFE8B65B), Color(0xFFD69E33)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "STUDENT DASHBOARD",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "Hello, Samer!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.white24,
//               child: Icon(
//                 Icons.person,
//                 color: Colors.white,
//                 size: 40,
//               ), // استبدلها بصورة المستخدم
//             ),
//           ],
//         ),
//         // TextField(
//         //   decoration: InputDecoration(
//         //     filled: true,
//         //     fillColor: Colors.white,
//         //     hintText: "Search for courses...",
//         //     prefixIcon: Icon(Icons.search, color: Colors.grey),
//         //     border: OutlineInputBorder(
//         //       borderRadius: BorderRadius.circular(15),
//         //       borderSide: BorderSide.none,
//         //     ),
//         //   ),
//         // ),
//       ],
//     ),
//   );
// }

// // 2. كارت "Continue Learning"
// Widget buildContinueLearningCard() {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     padding: EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(25),
//       boxShadow: [
//         BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
//       ],
//     ),
//     child: Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Icon(Icons.brush_outlined, color: AppColors.mainColor),
//             ),
//             SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Advanced UI Design with Figma",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Text(
//                     "Progress: 72%",
//                     style: TextStyle(color: Colors.grey, fontSize: 13),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 15),
//         LinearProgressIndicator(
//           value: 0.72,
//           backgroundColor: Colors.grey[200],
//           valueColor: AlwaysStoppedAnimation(AppColors.mainColor),
//         ),
//         SizedBox(height: 20),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.mainColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 15),
//             ),
//             child: Text(
//               "RESUME LESSON",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // 3. أيقونات الفئات
// Widget buildCategoryIcons() {
//   final categories = [
//     {"icon": Icons.book, "label": "LIBRARY"},
//     {"icon": Icons.emoji_events, "label": "CERTIFICATES"},
//     {"icon": Icons.calendar_month, "label": "EVENTS"},
//     {"icon": Icons.group, "label": "GROUPS"},
//   ];

//   return Padding(
//     padding: EdgeInsets.symmetric(vertical: 20),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: categories
//           .map(
//             (cat) => Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Icon(
//                     cat['icon'] as IconData,
//                     color: AppColors.mainColor,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   cat['label'] as String,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           )
//           .toList(),
//     ),
//   );
// }

// // 4. عناصر المهام (Tasks)
// Widget buildTaskItem(String date, String title, String subtitle) {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//     padding: EdgeInsets.all(15),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Row(
//       children: [
//         Container(
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.grey[50],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey[100]!),
//           ),
//           child: Column(
//             children: [
//               Text(
//                 date.split(" ")[0],
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: AppColors.mainColor,
//                 ),
//               ),
//               Text(
//                 date.split(" ")[1],
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 15),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//         Icon(Icons.chevron_right, color: Colors.grey[300]),
//       ],
//     ),
//   );
// }

// // ويدجت العناوين الفرعية
// Widget buildSectionHeader(String title, String action) {
//   return Padding(
//     padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: AppColors.blackColor,
//           ),
//         ),
//         Text(
//           action,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: AppColors.mainColor,
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // شريط التنقل السفلي
// Widget buildBottomNav() {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 10),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         navItem(Icons.home, "HOME", isActive: true),
//         navItem(Icons.search, "DISCOVER"),
//         navItem(Icons.menu_book, "COURSES"),
//         navItem(Icons.notifications, "ALERTS"),
//         navItem(Icons.person, "PROFILE"),
//       ],
//     ),
//   );
// }

// Widget navItem(IconData icon, String label, {bool isActive = false}) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Icon(icon, color: isActive ? AppColors.mainColor : Colors.grey[400]),
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 9,
//           fontWeight: FontWeight.bold,
//           color: isActive ? AppColors.mainColor : Colors.grey[400],
//         ),
//       ),
//     ],
//   );
// }
