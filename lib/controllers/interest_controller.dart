import 'package:get/get.dart';
import 'package:flutter/material.dart';

class InterestController extends GetxController {
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().obs;

  final RxInt dayMode = 30.obs;
  final RxBool snap1530 = false.obs;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController   = TextEditingController();
  final TextEditingController paidController   = TextEditingController();

  final RxDouble interestAmount = 0.0.obs;
  final RxDouble totalAmount    = 0.0.obs;
  final RxDouble balance        = 0.0.obs;
  final RxDouble changeAmount   = 0.0.obs;
  final RxDouble intsPerDay     = 0.0.obs;
  final RxDouble intsPerMonth   = 0.0.obs;

  final RxInt totalDays     = 0.obs;
  final RxInt days          = 0.obs;
  final RxInt months        = 0.obs;
  final RxInt years         = 0.obs;
  final RxInt effectiveDays = 0.obs;

  // Effective months + fractional days used in formula (for display clarity)
  final RxDouble effectiveT = 0.0.obs; // = whole months + (remDays / dpm)

  @override
  void onInit() {
    super.onInit();
    _recalculateDuration();
    amountController.addListener(calculate);
    rateController.addListener(calculate);
    paidController.addListener(calculate);
  }

  @override
  void onClose() {
    amountController.dispose();
    rateController.dispose();
    paidController.dispose();
    super.onClose();
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
    _recalculateDuration();
    calculate();
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
    _recalculateDuration();
    calculate();
  }

  void setDayMode(int mode) {
    dayMode.value = mode;
    _recalculateDuration();
    calculate();
  }

  void toggleSnap1530(bool value) {
    snap1530.value = value;
    _recalculateDuration();
    calculate();
  }

  void _recalculateDuration() {
    final start = startDate.value;
    final end   = endDate.value;

    if (end.isBefore(start)) {
      totalDays.value = 0; effectiveDays.value = 0; effectiveT.value = 0;
      days.value = 0; months.value = 0; years.value = 0;
      return;
    }

    totalDays.value = end.difference(start).inDays;

    // Actual calendar breakdown
    int y = end.year  - start.year;
    int m = end.month - start.month;
    int d = end.day   - start.day;
    if (d < 0) { m -= 1; d += DateTime(end.year, end.month, 0).day; }
    if (m < 0) { y -= 1; m += 12; }
    years.value  = y;
    months.value = m;
    days.value   = d;

    final dpm              = dayMode.value;          // 30 or 31
    final totalWholeMonths = y * 12 + m;

    if (!snap1530.value) {
      // Snap OFF → T = wholeMonths + (leftoverDays / dpm)
      effectiveT.value    = totalWholeMonths + (d / dpm);
      effectiveDays.value = totalDays.value;
    } else {
      // Snap ON → round leftover days to next 15-day boundary
      int snappedRemDays;
      int extraMonths;

      if (d == 0) {
        snappedRemDays = 0; extraMonths = 0;
      } else if (d <= 15) {
        snappedRemDays = 15; extraMonths = 0;
      } else {
        snappedRemDays = 0; extraMonths = 1;
      }

      final effWholeMonths = totalWholeMonths + extraMonths;
      effectiveT.value     = effWholeMonths + (snappedRemDays / dpm);
      effectiveDays.value  = effWholeMonths * dpm + snappedRemDays;
    }
  }

  void calculate() {
    final amount = double.tryParse(amountController.text) ?? 0;
    final rate   = double.tryParse(rateController.text)   ?? 0;
    final paid   = double.tryParse(paidController.text)   ?? 0;

    if (amount <= 0 || rate <= 0) {
      interestAmount.value = 0; totalAmount.value  = 0;
      balance.value        = 0; changeAmount.value = 0;
      intsPerDay.value     = 0; intsPerMonth.value = 0;
      return;
    }

    // Monthly interest formula:
    // I = P × (R / 100) × T
    // where T = wholeMonths + (remainderDays / dpm)
    // R is monthly rate (e.g. 2 means 2% per month)
    final t        = effectiveT.value;
    final interest = amount * (rate / 100) * t;
    final total    = amount + interest;

    interestAmount.value = interest;
    totalAmount.value    = total;
    balance.value        = (total - paid).clamp(0, double.infinity);
    changeAmount.value   = (paid - total).clamp(0, double.infinity);

    // Per month: interest for exactly 1 month
    intsPerMonth.value = amount * (rate / 100);

    // Per day: 1 month's interest divided by dpm
    intsPerDay.value = intsPerMonth.value / dayMode.value;
  }

  void reset() {
    startDate.value = DateTime.now();
    endDate.value   = DateTime.now();
    amountController.clear();
    rateController.clear();
    paidController.clear();
    dayMode.value  = 30;
    snap1530.value = false;
    _recalculateDuration();
    calculate();
  }
}