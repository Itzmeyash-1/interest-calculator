import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headingLarge = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AppColors.surface, letterSpacing: 0.5,
  );
  static const TextStyle headingMedium = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const TextStyle labelStyle = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary, letterSpacing: 0.3,
  );
  static const TextStyle valueStyle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );
  static const TextStyle resultValue = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
  static const TextStyle successValue = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700,
    color: AppColors.success,
  );
  static const TextStyle inputText = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static const TextStyle dateText = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
