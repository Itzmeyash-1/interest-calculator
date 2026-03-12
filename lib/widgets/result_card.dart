import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interest_controller.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<InterestController>();
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF0288D1)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 20, offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Calculation Results',
                  style: AppTextStyles.headingLarge.copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ResultItem(
                    label: 'Interest',
                    value: c.interestAmount.value,
                    icon: Icons.trending_up_rounded,
                  ),
                  _VerticalDivider(),
                  _ResultItem(
                    label: 'Total',
                    value: c.totalAmount.value,
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ],
              ),
            ),
           SizedBox(height: 8,),
           _SmallResultTile(
                    label: 'Balance Due',
                    value: c.balance.value,
                    icon: Icons.receipt_long_rounded,
                    isWarning: c.balance.value > 0,
                  ),

          ],
        ),
      );
    });
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;

  const _ResultItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '₹ ${value.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 50, width: 1, color: Colors.white30);
  }
}

class _SmallResultTile extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final bool isWarning;
  final bool isSuccess;

  const _SmallResultTile({
    required this.label,
    required this.value,
    required this.icon,
    this.isWarning = false,
    this.isSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSuccess
        ? Colors.green.withOpacity(0.2)
        : isWarning
            ? Colors.orange.withOpacity(0.2)
            : Colors.white.withOpacity(0.12);
    final textColor = isSuccess
        ? Colors.greenAccent
        : isWarning
            ? Colors.orangeAccent
            : Colors.white;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 13),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${value.toStringAsFixed(2)}',
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
