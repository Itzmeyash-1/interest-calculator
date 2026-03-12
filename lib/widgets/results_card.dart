// lib/widgets/results_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/interest_controller.dart';
import '../utils/app_theme.dart';

class ResultsCard extends StatelessWidget {
  final InterestController controller;

  const ResultsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Row(
              children: [
                const Icon(Icons.calculate_rounded,
                    color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Calculation Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Obx(() => _InterestBadge(
                      value: controller.interestAmount.value,
                    )),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: Colors.white.withOpacity(0.15),
          ),

          // Main result rows
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(() => _ResultRow(
                      label: 'Interest Amount',
                      value: controller.interestAmount.value,
                      icon: Icons.trending_up_rounded,
                      highlight: true,
                    )),
                const SizedBox(height: 10),
                Obx(() => _ResultRow(
                      label: 'Total Amount',
                      value: controller.totalAmount.value,
                      icon: Icons.account_balance_rounded,
                    )),
                const SizedBox(height: 10),
                Obx(() => _ResultRow(
                      label: 'Paid Amount',
                      value: double.tryParse(controller.paidController.text)?? 0,
                      icon: Icons.check_circle_rounded,
                    )),
                const SizedBox(height: 12),
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.15),
                ),
                const SizedBox(height: 12),
                Obx(() => _BalanceRow(
                      balance: controller.balance.value,
                      change: controller.changeAmount.value,
                    )),
              ],
            ),
          ),

          // Footer stats
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => _MiniStat(
                        label: 'Ints/Day',
                        value: controller.intsPerDay.value,
                      )),
                ),
                Container(
                  width: 1,
                  height: 32,
                  color: Colors.white.withOpacity(0.2),
                ),
                Expanded(
                  child: Obx(() => _MiniStat(
                        label: 'Ints/Month',
                        value: controller.intsPerMonth.value,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestBadge extends StatelessWidget {
  final double value;

  const _InterestBadge({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value > 0 ? '+${_fmt(value)}' : '₹0.00',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final bool highlight;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(highlight ? 0.25 : 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: Text(
            _fmt(value),
            key: ValueKey(value),
            style: TextStyle(
              color: Colors.white,
              fontSize: highlight ? 17 : 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final double balance;
  final double change;

  const _BalanceRow({required this.balance, required this.change});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BalanceTile(
            label: 'Balance Due',
            value: balance,
            isPositive: balance <= 0,
            icon: Icons.balance_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BalanceTile(
            label: 'Change',
            value: change,
            isPositive: change >= 0,
            icon: Icons.swap_horiz_rounded,
          ),
        ),
      ],
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final String label;
  final double value;
  final bool isPositive;
  final IconData icon;

  const _BalanceTile({
    required this.label,
    required this.value,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isPositive
            ? Colors.greenAccent.withOpacity(0.15)
            : Colors.redAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive
              ? Colors.greenAccent.withOpacity(0.3)
              : Colors.redAccent.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 14,
                  color: isPositive
                      ? Colors.greenAccent[200]
                      : Colors.redAccent[100]),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _fmt(value.abs()),
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 15,
                color: isPositive
                    ? Colors.greenAccent[200]
                    : Colors.redAccent[100],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            _fmt(value),
            key: ValueKey(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

String _fmt(double value) {
  final formatter = NumberFormat('#,##,##0.00', 'en_IN');
  return '₹${formatter.format(value)}';
}
