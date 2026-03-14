import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../utils/colors.dart';
import '../../auth/presentation/widgets/auth_widgets.dart';
import '../../courses/data/models/course_model.dart';
import '../../courses/presentations/cubit/course_cubit.dart';
import '../../homepage/presentations/cubit/category_cubit.dart';

// create some values
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);

class AddCoursesPage extends StatelessWidget {
  const AddCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetIt.I<CourseCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.jonquil,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Add New Course',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const AddCoursesForm(),
      ),
    );
  }
}

class AddCoursesForm extends StatefulWidget {
  const AddCoursesForm({super.key});

  @override
  State<AddCoursesForm> createState() => _AddCoursesFormState();
}

class _AddCoursesFormState extends State<AddCoursesForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imgLinkController = TextEditingController();

  // Set default values (avoiding nulls)
  String _selectedCollage = "";
  String _selectedYear = "1";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize selected college to the first available one if list isn't empty
    final categories = GetIt.I<CategoryCubit>().categories;
    if (categories.isNotEmpty) {
      _selectedCollage = categories.first.id!;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imgLinkController.dispose();
    super.dispose();
  }

  // REUSABLE HELPER: Shared with your Edit page logic
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
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
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
              value: value.isEmpty ? null : value,
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
    // ValueChanged<Color> callback
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LabeledInputFields(
            label: 'Course Title'.tr(context),
            hint: "Enter course title".tr(context),
            prefixIcon: Icons.title,
            controller: titleController,
          ),
          const SizedBox(height: 20),

          LabeledInputFields(
            label: 'Course Description'.tr(context),
            hint: "Write a detailed description".tr(context),
            controller: descriptionController,
            maxLines: 5,
          ),
          const SizedBox(height: 20),

          LabeledInputFields(
            label: 'Image Link'.tr(context),
            hint: "Enter image URL".tr(context),
            prefixIcon: Icons.image,
            controller: imgLinkController,
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
          ColorPicker(color: pickerColor, onColorChanged: changeColor),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.jonquil,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isLoading ? null : _handleCreate,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Create Course".tr(context),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SAFE CREATION LOGIC ---
  Future<void> _handleCreate() async {
    // Validation
    if (titleController.text.isEmpty || _selectedCollage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields".tr(context)),
          backgroundColor: AppColors.redWood,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Capture context references BEFORE the async gap
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // Find the college title from our categories
    final categories = GetIt.I<CategoryCubit>().categories;
    final String collegeTitle = categories
        .firstWhere(
          (e) => e.id == _selectedCollage,
          orElse: () => categories.first,
        )
        .title;

    try {
      // Assuming your model expects a unique ID (or leave empty if backend handles it)
      final newCourse = CourseModel(
        id: DateTime.now().millisecondsSinceEpoch
            .toString(), // Temporary ID logic
        title: titleController.text,
        description: descriptionController.text,
        collegeId: _selectedCollage,
        collegeTitle: collegeTitle,
        yearId: _selectedYear,
        color: "0xFF${pickerColor.hex}", // Default color or from a picker
        imgLink: imgLinkController.text, // Default empty image
      );

      // Call the Cubit
      await context.read<CourseCubit>().addCourseItem(newCourse);

      // Success logic using captured references
      messenger.showSnackBar(
        // ignore: use_build_context_synchronously
        SnackBar(content: Text("Course created successfully".tr(context))),
      );
      if (navigator.canPop()) navigator.pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
