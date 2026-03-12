import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interest_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class DurationDisplay extends StatelessWidget {
  const DurationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InterestController>();
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightBlue, AppColors.accentLight.withOpacity(0.4)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DurationChip(label: 'Years', value: c.years.value.toString()),
                _Divider(),
                _DurationChip(label: 'Months', value: c.months.value.toString()),
                _Divider(),
                _DurationChip(label: 'Days', value: c.days.value.toString()),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.date_range_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Total: ${c.totalDays.value} Days',
                    style: AppTextStyles.labelStyle.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _DurationChip extends StatelessWidget {
  final String label;
  final String value;
  const _DurationChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.valueStyle.copyWith(fontSize: 22)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.labelStyle),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 36, width: 1.5, color: AppColors.divider);
  }
}
