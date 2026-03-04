import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../general/widgets/loading_widget.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';
import 'category/category_card_widget.dart';
import 'category/category_chip_widget.dart';

enum WidgetType { labels, chips }

class CategoryHListSectionWidget extends StatelessWidget {
  final WidgetType widgetType;
  const CategoryHListSectionWidget({super.key, required this.widgetType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: BlocBuilder<CategoryCubit, CategoryState>(
          bloc: GetIt.I.get<CategoryCubit>()..fetchItems(),
          builder: (context, state) {
            if (state is CategoryError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            if (state is CategoryLoaded) {
              final categories = state.items;
              return Row(
                children: categories.map((category) {
                  return widgetType == WidgetType.chips
                      ? CategoryCardWidget(category: category)
                      : CategoryChipWidget(category: category);
                }).toList(),
              );
            }

            return SizedBox(
              height: 90,
              child: LoadingWidget(isFullWidth: true, numRows: 1),
            );
          },
        ),
      ),
    );
  }
}
