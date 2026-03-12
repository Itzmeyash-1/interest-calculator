import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interest_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class InterestRateInfo extends StatelessWidget {
  const InterestRateInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InterestController>();
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Expanded(
              child: _InfoTile(
                label: 'Ints / Day',
                value: '₹ ${c.intsPerDay.value.toStringAsFixed(4)}',
                icon: Icons.today_rounded,
                color: AppColors.primary,
              ),
            ),
            Container(width: 1, height: 40, color: AppColors.divider),
            Expanded(
              child: _InfoTile(
                label: 'Ints / Month',
                value: '₹ ${c.intsPerMonth.value.toStringAsFixed(2)}',
                icon: Icons.calendar_month_rounded,
                color: AppColors.skyBlue,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelStyle.copyWith(fontSize: 10)),
              Text(value, style: AppTextStyles.valueStyle.copyWith(color: color, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
