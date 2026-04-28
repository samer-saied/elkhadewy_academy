import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../general/presentations/cubits/locale_cubit.dart';
import '../../../../general/presentations/cubits/navigation_cubit.dart';
import '../../../../utils/colors.dart';
import '../../bloc/login_cubit.dart';
import '../../bloc/login_state.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _rememberMe = prefs.getBool('remember_me') ?? false;
        final autoSignInAllowed = prefs.getBool('auto_signin_allowed') ?? true;

        if (_rememberMe) {
          _phoneController.text = prefs.getString('saved_phone') ?? '';
          _passwordController.text = prefs.getString('saved_password') ?? '';

          // Trigger auto sign-in if credentials are fully loaded and allowed
          if (autoSignInAllowed &&
              _phoneController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty) {
            GetIt.I<LoginCubit>().login(
              phone: _phoneController.text,
              password: _passwordController.text,
            );
          }
        }
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool('remember_me', true);
      await prefs.setBool('auto_signin_allowed', true);
      await prefs.setString('saved_phone', _phoneController.text);
      await prefs.setString('saved_password', _passwordController.text);
    } else {
      await prefs.setBool('remember_me', false);
      await prefs.remove('auto_signin_allowed');
      await prefs.remove('saved_phone');
      await prefs.remove('saved_password');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(backgroundColor: AppColors.jonquil, elevation: 0),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.main,
              (route) => false,
            );
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.up,
                backgroundColor: AppColors.redWood,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            AppColors.jonquil,
                          ),
                        ),

                        onPressed: () {
                          if (context
                                  .read<LocaleCubit>()
                                  .state
                                  .locale
                                  .languageCode ==
                              'ar') {
                            context.read<LocaleCubit>().changeLanguage('en');
                          } else {
                            context.read<LocaleCubit>().changeLanguage('ar');
                          }
                        },
                        child: Text(
                          context
                                      .read<LocaleCubit>()
                                      .state
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? "English"
                              : "عربي",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // --- 1. Logo and Header ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Circle
                      CircleAvatar(
                        radius: 35, // Half of your 60px diameter
                        backgroundColor: AppColors.jonquil,
                        child: CircleAvatar(
                          radius: 33, // Subtract the border width (30 - 2)
                          backgroundImage: AssetImage(
                            "assets/logo/logo_light.jpg",
                          ),
                        ),
                      ),

                      const SizedBox(width: 7),
                      // Title and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login'.tr(context),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Enter your mobile and password'.tr(context),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Spacing after header
                  // --- 2. Email Input ---
                  LabeledInputFields(
                    label: 'Mobile'.tr(context),
                    hint: '01* **** ****',
                    prefixIcon: Icons.phone,
                    controller: _phoneController,
                    isPassword: false,
                    keyboardType: TextInputType.phone,
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

                  // --- 3. Password Input ---
                  LabeledInputFields(
                    label: 'Password'.tr(context),
                    hint: '*******',
                    prefixIcon: Icons.lock,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    isPasswordVisible: state.isPasswordVisible,
                    onTogglePassword: () =>
                        GetIt.I<LoginCubit>().togglePasswordVisibility(),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a password'.tr(context)
                        : null,
                  ),

                  // --- Forgot Password Link ---
                  // const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: AppColors.jonquil,
                      ),
                      Text(
                        'Remember me'.tr(context),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // --- 4. Log In Button ---
                  ElevatedButton(
                    onPressed: state.status == LoginStatus.loading
                        ? null
                        : () {
                            if (!(_formKey.currentState?.validate() ?? false)) {
                              return;
                            }
                            FocusScope.of(context).unfocus();
                            HapticFeedback.mediumImpact();
                            GetIt.I<NavigationCubit>().updateIndex(0);
                            _saveCredentials();
                            GetIt.I<LoginCubit>().login(
                              phone: _phoneController.text,
                              password: _passwordController.text,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.jonquil,
                      foregroundColor: Colors.white,
                    ),
                    child: state.status == LoginStatus.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Log In'.tr(context)),
                  ),
                  const SizedBox(height: 20),

                  // --- 5. Signup Link ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?".tr(context),
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle Signup Navigation
                          HapticFeedback.mediumImpact();
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          'Sign Up'.tr(context),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
