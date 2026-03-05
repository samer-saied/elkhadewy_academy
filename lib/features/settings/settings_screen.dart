import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        print(val);
                        if (val == "English") {
                          setState(() {
                            // GetIt.I<LocaleCubit>().changeLanguage('en');
                            // BlocProvider.of<ThemesCubit>(context).changeTheme();
                            context.read<LocaleCubit>().changeLanguage('en');
                            // Get.updateLocale(locale);
                            // GetStorage().write('lang', locale.languageCode);
                          });
                        } else {
                          setState(() {
                            // GetIt.I<LocaleCubit>().changeLanguage('ar');
                            context.read<LocaleCubit>().changeLanguage('ar');
                            // Get.updateLocale(locale);
                            // GetStorage().write('lang', locale.languageCode);
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
                        // Get.dialog(
                        //   barrierDismissible: false,
                        //   Dialog(
                        //     backgroundColor: Colorsansparent,
                        //     child: PopScope(
                        //       // onWillPop: () async => false,
                        //       child: Container(
                        //         padding: const EdgeInsets.all(10),
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.circular(20),
                        //         ),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           mainAxisSize: MainAxisSize.min,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Center(
                        //               child: Text(
                        //                 "WARNING",
                        //                 style: const TextStyle(
                        //                   color: AppColors.blackColor,
                        //                   fontSize: 18,
                        //                 ),
                        //               ),
                        //             ),
                        //             const SizedBox(height: 5),
                        //             const Icon(
                        //               Icons.delete,
                        //               color: AppColors.gmailColor,
                        //               size: 40,
                        //             ),
                        //             const SizedBox(height: 5),
                        //             Padding(
                        //               padding: const EdgeInsets.symmetric(
                        //                 horizontal: 10,
                        //               ),
                        //               child: Align(
                        //                 alignment: Alignment.center,
                        //                 child: Text(
                        //                   "You are about to delete your account.\nAre you sure you want to delete your account?",
                        //                   textAlign: TextAlign.center,
                        //                 ),
                        //               ),
                        //             ),
                        //             Divider(
                        //               color: AppColors.greyColor,
                        //               thickness: 1,
                        //             ),
                        //             Row(
                        //               children: [
                        //                 Expanded(
                        //                   child: ElevatedButton(
                        //                     style: ElevatedButton.styleFrom(
                        //                       minimumSize: const Size(0, 45),
                        //                       backgroundColor:
                        //                           AppColors.whiteColor,
                        //                       foregroundColor:
                        //                           AppColors.blackColor,
                        //                       shape: RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(8),
                        //                       ),
                        //                     ),
                        //                     onPressed: () {
                        //                       Get.back();
                        //                     },
                        //                     child: const Text(
                        //                       'NO',
                        //                       style: TextStyle(
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 const SizedBox(width: 10),
                        //                 Expanded(
                        //                   child: ElevatedButton(
                        //                     style: ElevatedButton.styleFrom(
                        //                       minimumSize: const Size(0, 45),
                        //                       backgroundColor:
                        //                           AppColors.gmailColor,
                        //                       foregroundColor:
                        //                           AppColors.whiteColor,
                        //                       shape: RoundedRectangleBorder(
                        //                         borderRadius:
                        //                             BorderRadius.circular(8),
                        //                       ),
                        //                     ),
                        //                     onPressed: () {
                        //                       if (mainController
                        //                           .currentStudent!
                        //                           .id!
                        //                           .isNotEmpty) {
                        //                         mainController.blockStudent();
                        //                         Get.find<MainController>()
                        //                                 .selectedIndex =
                        //                             0;
                        //                         Get.offAll(
                        //                           () => const LogInScreen(),
                        //                         );
                        //                         LocalStorage(
                        //                           GetStorage(),
                        //                         ).clearLoginStatus();
                        //                       }
                        //                     },
                        //                     child: const Text('YES'),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // );
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
