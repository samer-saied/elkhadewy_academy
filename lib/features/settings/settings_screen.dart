import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/core/navigation/app_routes.dart';
import 'package:unimind/features/auth/bloc/login_cubit.dart';
import 'package:unimind/features/auth/bloc/register_cubit.dart';

import '../../general/presentations/cubits/locale_cubit.dart';
import '../../general/widgets/headers_widgets.dart';
import '../../services/lang/app_localizations.dart';
import '../../utils/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ///
  ///
  ///
  ///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppColors.jonquil,
            pinned: true,
            snap: true,
            floating: true,
            title: SectionHeaderSmallWidget(
              title: "settings".tr(context),
              color: AppColors.whiteColor,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SectionHeaderWidget(
                    title: "change_language".tr(context),
                    action: "",
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField<String>(
                      hint: Text("select_language".tr(context)),
                      // initialValue: lang == null
                      //     ? "English"
                      //     : lang.languageCode == "en"
                      //     ? "English"
                      //     : "اللغه العربيه",
                      isDense: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(
                          10.0,
                          10.0,
                          10.0,
                          10.0,
                        ),
                      ),
                      validator: (value) => value == null
                          ? 'field is required'.tr(context)
                          : null,
                      onChanged: (val) {
                        if (val == "English") {
                          setState(() {
                            context.read<LocaleCubit>().changeLanguage('en');
                          });
                        } else {
                          setState(() {
                            context.read<LocaleCubit>().changeLanguage('ar');
                          });
                        }
                      },
                      items: ["English", "اللغه العربيه"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value == "English" ? "english" : "arabic",
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // const SizedBox(height: 15),
                  // SectionHeaderWidget(title: "Theme".tr(context), action: ""),
                  // DropdownButtonHideUnderline(
                  //   child: DropdownButtonFormField<String>(
                  //     hint: Text("Theme"),
                  //     // initialValue: lang == null
                  //     //     ? "English"
                  //     //     : lang.languageCode == "en"
                  //     //     ? "English"
                  //     //     : "اللغه العربيه",
                  //     isDense: true,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       contentPadding: EdgeInsets.fromLTRB(
                  //         10.0,
                  //         10.0,
                  //         10.0,
                  //         10.0,
                  //       ),
                  //     ),
                  //     validator: (value) => value == null
                  //         ? 'field is required'.tr(context)
                  //         : null,
                  //     onChanged: (val) {
                  //       if (val == "Dark") {
                  //         setState(() {
                  //           BlocProvider.of<ThemesCubit>(context).changeTheme();
                  //           // Get.updateLocale(locale);
                  //           // GetStorage().write('lang', locale.languageCode);
                  //         });
                  //       } else {
                  //         setState(() {
                  //           BlocProvider.of<ThemesCubit>(context).changeTheme();
                  //         });
                  //       }
                  //     },
                  //     items: ["Dark", "Light"].map((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                  SectionHeaderWidget(title: "Account".tr(context), action: ""),
                  SizedBox(
                    width: double.infinity, // Full width
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          AppColors.redWood,
                        ),
                      ),
                      onPressed: () {
                        String currentUserId =
                            GetIt.I<LoginCubit>().currentUser!.id;
                        GetIt.I<RegisterCubit>().deleteUser(
                          userId: currentUserId,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'User Deleted Successfully'.tr(context),
                            ),
                            backgroundColor: AppColors.redWood,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text('Delete Account'.tr(context)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
