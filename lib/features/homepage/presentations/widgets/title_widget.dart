import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
      child: Text(
        title[0].toUpperCase() + title.substring(1),
        style: Theme.of(
          context,
        ).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
