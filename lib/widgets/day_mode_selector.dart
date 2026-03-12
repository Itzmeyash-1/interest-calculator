import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interest_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class DayModeSelector extends StatelessWidget {
  const DayModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InterestController>();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calculation Mode', style: AppTextStyles.labelStyle),
          const SizedBox(height: 8),
          Row(
            children: [
              _RadioTile(
                label: '31 Days / Month',
                value: 31,
                groupValue: c.dayMode.value,
                onChanged: c.setDayMode,
              ),
              const SizedBox(width: 12),
              _RadioTile(
                label: '30 Days / Month',
                value: 30,
                groupValue: c.dayMode.value,
                onChanged: c.setDayMode,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _SnapCheckbox(
            label: '15 / 30 Days',
            value: c.snap1530.value,          // ← was snap15Days
            onChanged: c.toggleSnap1530,      // ← was toggleSnap15Days
          ),
        ],
      );
    });
  }
}

class _RadioTile extends StatelessWidget {
  final String label;
  final int value;
  final int groupValue;
  final Function(int) onChanged;

  const _RadioTile({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.inputBorder,
              width: 1.5,
            ),
            boxShadow: selected
                ? [BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 18, height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? Colors.white : AppColors.inputBorder,
                    width: 2,
                  ),
                  color: selected ? Colors.white : Colors.transparent,
                ),
                child: selected
                    ? Center(
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                  ),
                )
                    : null,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SnapCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const _SnapCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(                   // ← removed Expanded (not in a Row)
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: value ? AppColors.accentLight.withOpacity(0.5) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value ? AppColors.skyBlue : AppColors.inputBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18, height: 18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: value ? AppColors.skyBlue : Colors.transparent,
                border: Border.all(
                  color: value ? AppColors.skyBlue : AppColors.inputBorder,
                  width: 2,
                ),
              ),
              child: value
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: value ? AppColors.skyBlue : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}