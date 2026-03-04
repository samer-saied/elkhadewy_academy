import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/homepage/presentations/screens/home_page.dart';
import 'features/more/more_page.dart';
import 'features/path/presentation/path_screen.dart';
import 'general/presentations/bottombar/bottom_bar_widget.dart';
import 'general/presentations/cubits/navigation_cubit.dart';
import 'utils/colors.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final List<Widget> _pages = const [
    HomePage(),
    SelectPathScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(backgroundColor: AppColors.jonquil, elevation: 0),
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          // Display the widget corresponding to the current index
          return _pages[state.currentIndex];
        },
      ),
      bottomNavigationBar: BottomBarWidget(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     BlocProvider.of<ThemesCubit>(context).changeTheme();
      //     // Localizations.localeOf(context).languageCode == 'en'
      //     //     ? BlocProvider.of<LocaleCubit>(context).changeLanguage('ar')
      //     //     : BlocProvider.of<LocaleCubit>(context).changeLanguage('en');
      //   },
      //   child: Icon(
      //     Localizations.localeOf(context).languageCode == 'en'
      //         ? Icons.local_play
      //         : Icons.language,
      //   ),
      // ),
    );
  }
}
