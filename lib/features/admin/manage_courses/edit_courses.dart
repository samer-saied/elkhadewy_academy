import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../utils/colors.dart';
import '../../auth/presentation/widgets/auth_widgets.dart';
import '../../courses/data/models/course_model.dart';
import '../../courses/presentations/cubit/course_cubit.dart';
import '../../homepage/presentations/cubit/category_cubit.dart';

class EditCoursesPage extends StatelessWidget {
  final CourseModel courses;
  const EditCoursesPage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // Use .value because GetIt manages the instance
      value: GetIt.I<CourseCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.jonquil,
          title: Text(
            'Edit Courses Post'.tr(context),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: EditCoursesForm(courses: courses),
      ),
    );
  }
}

class EditCoursesForm extends StatefulWidget {
  final CourseModel courses;
  const EditCoursesForm({super.key, required this.courses});

  @override
  State<EditCoursesForm> createState() => _EditCoursesFormState();
}

class _EditCoursesFormState extends State<EditCoursesForm> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late String _selectedCollage;
  late String _selectedYear;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.courses.title);
    descriptionController = TextEditingController(
      text: widget.courses.description,
    );
    _selectedCollage = widget.courses.collegeId;
    _selectedYear = widget.courses.yearId;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // --- Helper for Conciseness ---
  Widget _buildLabeledDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LabeledInputFields(
            label: 'Course Title'.tr(context),
            controller: titleController,
            prefixIcon: Icons.title,
            hint: 'Enter Course Title'.tr(context),
          ),
          const SizedBox(height: 20),
          LabeledInputFields(
            label: 'Course Description'.tr(context),
            controller: descriptionController,
            maxLines: 5,
            hint: 'Enter Course Description'.tr(context),
          ),
          const SizedBox(height: 20),

          _buildLabeledDropdown(
            label: "Select College".tr(context),
            value: _selectedCollage,
            items: GetIt.I<CategoryCubit>().categories
                .map((e) => DropdownMenuItem(value: e.id, child: Text(e.title)))
                .toList(),
            onChanged: (v) => setState(() => _selectedCollage = v ?? ""),
          ),

          const SizedBox(height: 20),

          _buildLabeledDropdown(
            label: "Select Year".tr(context),
            value: _selectedYear,
            items: [
              '1',
              '2',
              '3',
              '4',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _selectedYear = v ?? '1'),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleUpdate,
              child: Text("Update Course".tr(context)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Logic Extraction (Clean & Safe) ---
  Future<void> _handleUpdate() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // 1. Resolve data BEFORE the await
    final categories = GetIt.I<CategoryCubit>().categories;
    final String collegeTitle = categories
        .firstWhere(
          (e) => e.id == _selectedCollage,
          orElse: () => categories.first,
        )
        .title;

    final updatedModel = widget.courses.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      collegeId: _selectedCollage,
      collegeTitle: collegeTitle,
      yearId: _selectedYear,
    );

    // 2. Execute Async
    await context.read<CourseCubit>().updateCourseItem(updatedModel);

    // 3. Use captured references (No "deactivated" error)
    messenger.showSnackBar(
      SnackBar(
        content: Text("Course Edited successfully".tr(context)),
        backgroundColor: AppColors.emerald,
      ),
    );
    if (navigator.canPop()) navigator.pop();
  }
}
