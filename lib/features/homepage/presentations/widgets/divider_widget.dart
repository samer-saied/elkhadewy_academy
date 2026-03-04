import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: MediaQuery.sizeOf(context).width * 0.3,
        right: MediaQuery.sizeOf(context).width * 0.3,
        top: 10,
      ),
      child: Divider(),
    );
  }
}
