import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:unimind/services/lang/app_localizations.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../utils/colors.dart';
import '../../homepage/presentations/cubit/news_cubit.dart';
import '../../homepage/presentations/widgets/news_section_widget.dart';

class ManageNewsPage extends StatefulWidget {
  const ManageNewsPage({super.key});

  @override
  State<ManageNewsPage> createState() => _ManageNewsPageState();
}

class _ManageNewsPageState extends State<ManageNewsPage> {
  final _cubit = GetIt.I<NewsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchNewsItems(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.jonquil,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Manage News'.tr(context),
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NewsLoaded) {
            if (state.items.isEmpty) {
              return Center(child: Text("No news found".tr(context)));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return NewsCardWidget(
                  newsItem: state.items[index],
                  isAdmin: true,
                  onTapFunc: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editNews,
                      arguments: state.items[index],
                    ).then((_) {
                      // Re-fetch when returning from EditNewsPage
                      _cubit.fetchNewsItems(forceRefresh: true);
                    });
                  },
                );
              },
            );
          }
          return Center(child: Text("No news found".tr(context)));
        },
      ),
    );
  }
}
