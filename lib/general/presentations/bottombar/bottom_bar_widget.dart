// --- MAIN WIDGETS ---

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:unimind/services/lang/app_localizations.dart';

import '../cubits/navigation_cubit.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final stateNavigation = GetIt.I<NavigationCubit>();

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: stateNavigation.state.currentIndex,
          onTap: (value) => stateNavigation.updateIndex(value),
          items: [
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
              label: 'Home'.tr(context),
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01),
              label: 'Discover'.tr(context),
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedMoreVerticalCircle01),
              label: 'More'.tr(context),
            ),
          ],
        );
      },
    );
  }
}
