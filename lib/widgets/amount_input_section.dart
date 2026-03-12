import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/interest_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AmountInputSection extends StatelessWidget {
  const AmountInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InterestController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Loan Details', style: AppTextStyles.headingMedium),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'Principal Amount',
                hint: '0.00',
                icon: Icons.currency_rupee_rounded,
                controller: c.amountController,
                isAmount: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'Interest Rate (%)',
                hint: '0.00',
                icon: Icons.percent_rounded,
                controller: c.rateController,
                isAmount: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InputField(
          label: 'Amount Paid',
          hint: '0.00',
          icon: Icons.payments_rounded,
          controller: c.paidController,
          isAmount: true,
          fullWidth: true,
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isAmount;
  final bool fullWidth;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.isAmount,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelStyle),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.inputBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 8, offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
            style: AppTextStyles.inputText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 16),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
