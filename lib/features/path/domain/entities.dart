// import 'package:flutter/material.dart';

// class CollegeEntity {
//   final int id;
//   final String title;
//   final String subtitle;
//   final IconData icon;

//   CollegeEntity({
//     required this.id,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//   });
// }

class AcademicYearEntity {
  final int id;
  final String label;

  AcademicYearEntity({required this.id, required this.label});
}

// final List<CollegeEntity> colleges = [
//   CollegeEntity(
//     id: 1,
//     title: 'English Section',
//     subtitle: 'Faculty of Commerce',
//     icon: Icons.engineering,
//   ),
//   CollegeEntity(
//     id: 2,
//     title: 'Arabic Section',
//     subtitle: 'Faculty of Commerce',
//     icon: Icons.medical_services,
//   ),
//   CollegeEntity(
//     id: 3,
//     title: 'BIS',
//     subtitle: 'Business Information Systems',
//     icon: Icons.account_balance,
//   ),
//   CollegeEntity(
//     id: 4,
//     title: 'AFT',
//     subtitle: 'Accounting and financial technology',
//     icon: Icons.palette,
//   ),
// ];

final List<AcademicYearEntity> years = [
  AcademicYearEntity(id: 1, label: '1st Year'),
  AcademicYearEntity(id: 2, label: '2nd Year'),
  AcademicYearEntity(id: 3, label: '3rd Year'),
  AcademicYearEntity(id: 4, label: '4th Year'),
  AcademicYearEntity(id: 5, label: 'Graduate'),
];
