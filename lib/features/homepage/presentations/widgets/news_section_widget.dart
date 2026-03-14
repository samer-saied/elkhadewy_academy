import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/navigation/app_routes.dart';
import '../../../../general/widgets/loading_widget.dart';
import '../../../../utils/colors.dart';
import '../../data/model/news_item_model.dart';
import '../cubit/news_cubit.dart';

class NewsSectionWidget extends StatefulWidget {
  const NewsSectionWidget({super.key});

  @override
  State<NewsSectionWidget> createState() => _NewsSectionWidgetState();
}

class _NewsSectionWidgetState extends State<NewsSectionWidget> {
  @override
  Widget build(BuildContext context) {
    // GetIt.I.get<NewsCubit>().fetchNewsItems();
    return Container(
      constraints: BoxConstraints(minHeight: 140),
      height: MediaQuery.sizeOf(context).height / 6,
      width: MediaQuery.sizeOf(context).width,
      child: BlocBuilder<NewsCubit, NewsState>(
        bloc: GetIt.I.get<NewsCubit>()..fetchNewsItems(),
        builder: (context, state) {
          if (state is NewsLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return NewsCardWidget(
                  newsItem: state.items[index],
                  onTapFunc: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.singleNews,
                      arguments: state.items[index],
                    );
                  },
                );
              },
            );
          }
          return LoadingWidget(isFullWidth: false, numRows: 3);
        },
      ),
    );
  }
}

class NewsCardWidget extends StatelessWidget {
  final NewsItemModel newsItem;
  final Function()? onTapFunc;
  final bool isAdmin;
  const NewsCardWidget({
    super.key,
    required this.newsItem,
    this.onTapFunc,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTapFunc,
      child: Dismissible(
        key: Key(newsItem.id!),
        direction: isAdmin
            ? DismissDirection.endToStart
            : DismissDirection.none,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            GetIt.I.get<NewsCubit>().deleteNewsItem(newsItem.id!);
            GetIt.I.get<NewsCubit>().fetchNewsItems(forceRefresh: true);
          }
        },
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: AppColors.redWood,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Icon(Icons.delete, color: Colors.white)],
          ),
        ),
        child: Container(
          width: isAdmin
              ? MediaQuery.sizeOf(context).width
              : MediaQuery.sizeOf(context).width * 0.8,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: AppColors.jonquil,
                      shape: BoxShape.circle,
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedNews,
                      color: AppColors.whiteColor,
                      size: 16.0,
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      newsItem.title,
                      maxLines: 2,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.blackColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3, left: 5, right: 5),
                child: Text(
                  newsItem.description,
                  maxLines: 2,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (newsItem.date != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    timeago.format(DateTime.parse(newsItem.date!)),
                    style: textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
