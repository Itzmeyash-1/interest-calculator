import 'package:flutter/material.dart';

import '../utils/app_colors.dart';


class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 15, offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}