import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final bool isFullWidth;
  final int numRows;
  const LoadingWidget({
    super.key,
    required this.isFullWidth,
    required this.numRows,
  });

  @override
  Widget build(BuildContext context) {
    final Size currentSize = MediaQuery.sizeOf(context);

    switch (numRows) {
      case 1:
        return BuildShimmerLine(
          width: isFullWidth ? currentSize.width : currentSize.width / 2.3,
        );

      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(numRows, (index) {
            return BuildShimmerLine(
              width: currentSize.width * (index + 1) / 5,
              height: 12,
            );
          }).toList(),
        );
    }
  }
}

class BuildShimmerLine extends StatelessWidget {
  final double width;
  final double? height;
  const BuildShimmerLine({super.key, required this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.brightnessOf(context) == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      period: const Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
