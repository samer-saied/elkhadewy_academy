import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({super.key});

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {
  bool isClicked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(backgroundColor: AppColors.prussianBlue, elevation: 0),
      ),
      body: Placeholder(),
    );
  }
}
