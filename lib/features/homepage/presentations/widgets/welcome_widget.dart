import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unimind/services/lang/app_localizations.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../../auth/bloc/login_cubit.dart';

/////////////// Welcome Widget && Profile Widget  ///////////////
class WelcomeUserWidget extends StatefulWidget {
  const WelcomeUserWidget({super.key});

  @override
  State<WelcomeUserWidget> createState() => _WelcomeUserWidgetState();
}

class _WelcomeUserWidgetState extends State<WelcomeUserWidget> {
  String _lastLoginText = 'Never';

  @override
  void initState() {
    super.initState();
    _loadLastLoginTime();
  }

  Future<void> _loadLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('last_login_time');
    if (stored != null && mounted) {
      final lastLogin = DateTime.tryParse(stored);
      if (lastLogin != null && mounted) {
        setState(() {
          _lastLoginText = timeago.format(lastLogin);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /////////////// Welcome TEXT widget with Notification Icon  ///////////////
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${"Welcome Back".tr(context)},",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
              ///////////////   Notification CustomIcon button. ///////////////
              // NotificationButton(),
            ],
          ),
        ),

        ///////////////   Profile Widget    ///////////////
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.pushNamed(context, AppRoutes.profilePage);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  child: HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 30),
                ),
                SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GetIt.I.get<LoginCubit>().currentUser!.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    Text(
                      "last login at: $_lastLoginText",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.lightGrey.withAlpha(30),
              width: 1,
            ),
          ),
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            size: 30,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
