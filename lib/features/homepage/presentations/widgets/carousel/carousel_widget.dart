import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../general/widgets/loading_widget.dart';
import '../../cubit/carousel_cubit.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarouselCubit, CarouselState>(
      bloc: GetIt.I<CarouselCubit>()..fetchCarouselItems(),
      builder: (context, state) {
        if (state is CarouselLoaded) {
          if (state.items.isEmpty) {
            return const SizedBox.shrink();
          }
          return Container(
            constraints: BoxConstraints(minHeight: 150),
            height: MediaQuery.sizeOf(context).height / 4,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15), // Subtle shadow color
                  spreadRadius: 1, // Determines how far the shadow spreads
                  blurRadius: 3, // Softness of the shadow
                  offset: const Offset(0, 2), // Shadow position (x, y)
                ),
              ],
            ),
            child: Swiper(
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return ClipRect(
                  child: CachedNetworkImage(
                    imageUrl: state.items[index].urlImage,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        LoadingWidget(isFullWidth: true, numRows: 1),
                  ),
                );
              },
              itemCount: state.items.length,
              pagination: SwiperPagination(alignment: Alignment.bottomCenter),
              control: SwiperControl(),
            ),
          );
        }
        if (state is CarouselLoading) {
          return LoadingWidget(isFullWidth: true, numRows: 1);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
