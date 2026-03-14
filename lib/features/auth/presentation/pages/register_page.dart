import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Works for Cubit too
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../bloc/register_cubit.dart';
import '../../bloc/register_state.dart';
import '../widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  String _selectedFaculty = 'BIS';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Create new account".tr(context),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // Use BlocBuilder with the Cubit
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "something gone wrong,try again later".tr(context),
                ),
              ),
            );
          }
          if (state.status == RegisterStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Account created successfully".tr(context)),
                backgroundColor: AppColors.emerald,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();

          return registerBodyWidget(context, state, cubit);
        },
      ),
    );
  }

  Widget registerBodyWidget(
    BuildContext context,
    RegisterState state,
    RegisterCubit cubit,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // --- Header ---
            Center(
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.lightGrey,
                child: CircleAvatar(
                  radius: 37, // Subtract the border width (30 - 2)
                  backgroundImage: AssetImage("assets/logo/logo_light.jpg"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to\nyour educational journey'.tr(context),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your information to join us'.tr(context),

              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 14,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // --- Input Fields ---
            LabeledInputFields(
              label: 'Full Name'.tr(context),
              hint: 'Enter your full name'.tr(context),
              prefixIcon: Icons.person,
              controller: _nameController,
              keyboardType: TextInputType.text,
              isEnabled: state.status != RegisterStatus.loading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter fullname';
                }
                if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                  return 'Only English letters allowed'.tr(context);
                }
                return null;
              },
              // => value == null || value.isEmpty
              //     ? 'Please enter your full name'.tr(context)
              //     : null,
            ),
            LabeledInputFields(
              label: 'Mobile'.tr(context),
              hint: '01* **** ****',
              prefixIcon: Icons.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              isEnabled: state.status != RegisterStatus.loading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number'.tr(context);
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Only English numbers allowed'.tr(context);
                }
                return null;
              },
            ),

            LabeledInputFields(
              label: 'Password'.tr(context),
              hint: '*******',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: _passwordController,
              isPasswordVisible: state.isPasswordVisible,
              isEnabled: state.status != RegisterStatus.loading,
              // CUBIT CALL:
              onTogglePassword: () => cubit.togglePasswordVisibility(),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a password'.tr(context)
                  : null,
            ),

            LabeledInputFields(
              label: 'Email'.tr(context),
              hint: 'example@domain.com',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,

              isEnabled: state.status != RegisterStatus.loading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email'.tr(context);
                }
                if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(value)) {
                  return 'Please enter a valid email'.tr(context);
                }
                return null;
              },
            ),

            // --- Study Data Section ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),

                        // GoogleFonts.cairo(
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 16,
                        // ),
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

                    // GoogleFonts.cairo(color: AppColors.textDark),
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

                          onTap: () {
                            setState(() {
                              _selectedFaculty = value;
                            });
                            ///////////
                            ///
                            ///
                            ///
                          },
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        if (state.status == RegisterStatus.loading) {
                          return;
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

                    // GoogleFonts.cairo(color: AppColors.textDark),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildYearOption(cubit, state, 0, 'First'.tr(context)),
                      _buildYearOption(cubit, state, 1, 'Second'.tr(context)),
                      _buildYearOption(cubit, state, 2, 'Third'.tr(context)),
                      _buildYearOption(cubit, state, 3, 'Fourth'.tr(context)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Submit Button ---
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.jonquil, AppColors.jonquil],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: state.status == RegisterStatus.loading
                    ? null
                    : () {
                        if (!(_formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        // CUBIT CALL:
                        cubit.submitForm(
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          password: _passwordController.text,
                          faculty: _selectedFaculty,
                          studyYear: state.selectedYearIndex.toString(),
                        );
                        // Navigator.pushNamed(context, AppRoutes.main);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state.status == RegisterStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Account'.tr(context),
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteColor,
                                ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.person_add_alt_1,
                            color: AppColors.whiteColor,
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),
            // --- Footer ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?'.tr(context),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: AppColors.grey),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Login'.tr(context),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.jonquil,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _buildYearOption(
  RegisterCubit cubit,
  RegisterState state,
  int index,
  String label,
) {
  return YearSelectionChip(
    label: label,
    isSelected: state.selectedYearIndex == index,
    // CUBIT CALL:
    onTap: () => cubit.selectYear(index),
  );
}
