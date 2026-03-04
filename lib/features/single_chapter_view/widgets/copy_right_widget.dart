import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/colors.dart';
import '../../auth/bloc/login_cubit.dart';

class CopyRigthsWidget extends StatefulWidget {
  final bool isSafeArea;
  const CopyRigthsWidget({super.key, this.isSafeArea = false});

  @override
  State<CopyRigthsWidget> createState() => _CopyRigthsWidgetState();
}

class _CopyRigthsWidgetState extends State<CopyRigthsWidget> {
  late Timer timer;
  int durationTime = 10000;
  double topPadding = 0;
  double downPadding = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer = Timer.periodic(Duration(milliseconds: durationTime), (__) {
        topPadding =
            Random().nextDouble() * (MediaQuery.sizeOf(context).height * 0.25);
        downPadding =
            Random().nextDouble() * (MediaQuery.sizeOf(context).width / 2);
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topPadding,
      right: downPadding,
      child: AnimatedContainer(
        duration: Duration(milliseconds: durationTime),
        padding: EdgeInsets.only(top: topPadding, left: downPadding),

        child: Text(
          GetIt.I<LoginCubit>().currentUser!.phone,
          style: TextStyle(
            color: AppColors.whiteColor.withValues(alpha: 0.6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
