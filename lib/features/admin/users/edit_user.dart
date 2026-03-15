import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/features/auth/bloc/register_cubit.dart';
import 'package:unimind/features/courses/presentations/cubit/course_cubit.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../utils/colors.dart';
import '../../auth/models/user_model.dart';
import '../../auth/presentation/widgets/auth_widgets.dart';
import 'widgets/multi_select_widget.dart';

class EditUserPage extends StatefulWidget {
  final UserModel userModel;

  const EditUserPage({super.key, required this.userModel});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late String _selectedFaculty;
  late int _selectedYearIndex;
  late String _selectedRole;
  late String _selectedStatus;
  late bool _refreshUserStatus;
  late bool _userHeadset;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userModel.name);
    _emailController = TextEditingController(text: widget.userModel.email);
    _phoneController = TextEditingController(text: widget.userModel.phone);
    _passwordController = TextEditingController(
      text: widget.userModel.password,
    );

    _selectedFaculty =
        ['BIS', 'ARABIC', 'ENGLISH', 'AFT'].contains(widget.userModel.faculty)
        ? widget.userModel.faculty
        : 'BIS';
    _selectedYearIndex =
        int.tryParse(widget.userModel.studyYear.toString()) ?? 0;

    _selectedRole =
        ['student', 'teacher', 'admin'].contains(widget.userModel.role)
        ? widget.userModel.role
        : 'student';

    _selectedStatus = ['active', 'blocked'].contains(widget.userModel.status)
        ? widget.userModel.status
        : 'active';

    _userHeadset = widget.userModel.statusEnableHeadset;
    _refreshUserStatus = widget.userModel.refreshToken;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Construct the updated UserModel
    final updatedUser = UserModel(
      id: widget.userModel.id,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      faculty: _selectedFaculty,
      studyYear: _selectedYearIndex.toString(),
      role: _selectedRole,
      materials: widget.userModel.materials,
      createdAt: widget.userModel.createdAt,
      updatedAt: Timestamp.now(),
      deviceId: widget.userModel.deviceId,
      status: _selectedStatus,
      refreshToken: _refreshUserStatus,
      statusEnableHeadset: _userHeadset,
    );

    // Call your logic here to save the updatedUser to back-end
    GetIt.I<RegisterCubit>().updateUser(updatedUser);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User details updated!'),
        backgroundColor: AppColors.emerald,
      ),
    );
  }

  Widget _buildYearOption(int index, String label) {
    return YearSelectionChip(
      label: label.tr(context),
      isSelected: _selectedYearIndex == index,
      onTap: () => setState(() => _selectedYearIndex = index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit User".tr(context),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabeledInputFields(
                label: 'Full Name'.tr(context),
                hint: 'Enter your full name'.tr(context),
                prefixIcon: Icons.person,
                controller: _nameController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your full name'.tr(context)
                    : null,
              ),
              LabeledInputFields(
                label: 'Email'.tr(context),
                hint: 'example@domain.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your email'.tr(context)
                    : null,
              ),
              LabeledInputFields(
                label: 'Mobile'.tr(context),
                hint: '01** **** ****',
                prefixIcon: Icons.phone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your mobile number'.tr(context)
                    : null,
              ),
              LabeledInputFields(
                label: 'Password'.tr(context),
                hint: '*******',
                prefixIcon: Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
                // isPasswordVisible: false,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a password'.tr(context)
                    : null,
              ),

              // Study Data Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.jonquilLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        const Icon(Icons.menu_book, color: AppColors.jonquil),
                        const SizedBox(width: 10),
                        Text(
                          'Study Data'.tr(context),
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Faculty Selection
                    Text(
                      'Faculty'.tr(context),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        value: _selectedFaculty,
                        items: ['BIS', 'ARABIC', 'ENGLISH', 'AFT'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedFaculty = val;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Year Selection
                    Text(
                      'Study Year'.tr(context),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      children: [
                        _buildYearOption(0, 'First'),
                        _buildYearOption(1, 'Second'),
                        _buildYearOption(2, 'Third'),
                        _buildYearOption(3, 'Fourth'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Admin Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.jonquilLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        const Icon(
                          Icons.admin_panel_settings,
                          color: AppColors.jonquil,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Admin Settings',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Role Selection
                    Text(
                      'Role',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        value: _selectedRole,
                        items: ['student', 'teacher', 'admin'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedRole = val;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Status Selection
                    Text(
                      'Account Status',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        value: _selectedStatus,
                        items: ['active', 'blocked'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedStatus = val;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Refresh Token',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: AppColors.blackColor),
                        ),
                        Switch.adaptive(
                          value: _refreshUserStatus,
                          onChanged: (val) {
                            setState(() {
                              _refreshUserStatus = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Headset Required',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: AppColors.blackColor),
                        ),
                        Switch.adaptive(
                          value: _userHeadset,
                          onChanged: (val) {
                            setState(() {
                              _userHeadset = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /////////////// Materials Section ///////////////
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.jonquilLight.withAlpha(20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        const Icon(Icons.menu_book, color: AppColors.jonquil),
                        const SizedBox(width: 10),
                        Text(
                          'Materials'.tr(context),
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<CourseCubit, CourseState>(
                      bloc: GetIt.I<CourseCubit>()..fetchCourseItems(),
                      builder: (context, state) {
                        return MultiSelect(
                          userItems: widget.userModel.materials,
                          items: GetIt.I<CourseCubit>().allCourses,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ////////////////  BUTTON  //////////////////
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [AppColors.jonquil, AppColors.jonquil],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
