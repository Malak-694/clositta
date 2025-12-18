import 'package:flutter/material.dart';

import '../constants/colors.dart';

class circleIndicator extends StatelessWidget {
  const circleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: const CircularProgressIndicator(
          // Set the color to purple
          color: AppColors.primery,
          // Optionally set the thickness
          strokeWidth: 5.0,
        ),
      ),
    );
  }
}
