import 'package:get/get.dart';
import 'package:flutter/material.dart';

class InterestController extends GetxController {
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate   = DateTime.now().obs;

  final RxInt  dayMode       = 30.obs;
  final RxBool snap1530      = false.obs;
  final RxBool compoundYearly = false.obs; // ← NEW

  final TextEditingController amountController = TextEditingController();
  final TextEditingController rateController   = TextEditingController();
  final TextEditingController paidController   = TextEditingController();

  final RxDouble interestAmount     = 0.0.obs;
  final RxDouble totalAmount        = 0.0.obs;
  final RxDouble balance            = 0.0.obs;
  final RxDouble changeAmount       = 0.0.obs;
  final RxDouble intsPerDay         = 0.0.obs;
  final RxDouble intsPerMonth       = 0.0.obs;

  final RxInt    totalDays          = 0.obs;
  final RxInt    days               = 0.obs;
  final RxInt    months             = 0.obs;
  final RxInt    years              = 0.obs;
  final RxInt    effectiveDays      = 0.obs;
  final RxDouble effectiveT         = 0.0.obs;

  final RxInt    compoundYears      = 0.obs;
  final RxDouble baseAfterCompound  = 0.0.obs;

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

  // ← NEW
  void toggleCompoundYearly(bool value) {
    compoundYearly.value = value;
    calculate(); // no need to recalculate duration, only affects formula
  }

  // ── Duration breakdown — UNCHANGED ───────────────────────────────
  void _recalculateDuration() {
    final start = startDate.value;
    final end   = endDate.value;

    if (end.isBefore(start)) {
      totalDays.value = 0; effectiveDays.value = 0; effectiveT.value = 0;
      days.value = 0; months.value = 0; years.value = 0;
      return;
    }

    totalDays.value = end.difference(start).inDays;

    int y = end.year  - start.year;
    int m = end.month - start.month;
    int d = end.day   - start.day;
    if (d < 0) { m -= 1; d += DateTime(end.year, end.month, 0).day; }
    if (m < 0) { y -= 1; m += 12; }
    years.value  = y;
    months.value = m;
    days.value   = d;

    final dpm = dayMode.value;

    if (!snap1530.value) {
      effectiveT.value    = m + (d / dpm);
      effectiveDays.value = totalDays.value;
    } else {
      int snappedRemDays;
      int extraMonths;

      if (d == 0) {
        snappedRemDays = 0; extraMonths = 0;
      } else if (d <= 15) {
        snappedRemDays = 15; extraMonths = 0;
      } else {
        snappedRemDays = 0; extraMonths = 1;
      }

      final effMonths     = m + extraMonths;
      effectiveT.value    = effMonths + (snappedRemDays / dpm);
      effectiveDays.value = y * dpm * 12 + effMonths * dpm + snappedRemDays;
    }
  }

  // ── Interest calculation ──────────────────────────────────────────
  void calculate() {
    final amount = double.tryParse(amountController.text) ?? 0;
    final rate   = double.tryParse(rateController.text)   ?? 0;
    final paid   = double.tryParse(paidController.text)   ?? 0;

    if (amount <= 0 || rate <= 0) {
      interestAmount.value    = 0; totalAmount.value       = 0;
      balance.value           = 0; changeAmount.value      = 0;
      intsPerDay.value        = 0; intsPerMonth.value      = 0;
      compoundYears.value     = 0; baseAfterCompound.value = 0;
      return;
    }

    final dpm       = dayMode.value.toDouble();
    final fullYears = years.value;
    final tRem      = effectiveT.value; // sub-year remainder in months

    double totalInterest;
    double total;

    if (!compoundYearly.value) {
      // ── Simple interest (monthly formula) ──────────────────────────
      // I = P × (R/100) × T
      // T = totalWholeMonths + (leftoverDays / dpm)
      // Uses effectiveT which already includes years converted to months
      // BUT effectiveT only holds sub-year remainder — add years back
      final tTotal   = (fullYears * 12) + tRem;
      totalInterest  = amount * (rate / 100) * tTotal;
      total          = amount + totalInterest;

      compoundYears.value     = 0;
      baseAfterCompound.value = amount;

    } else {
      // ── Compound yearly ────────────────────────────────────────────
      // Step 1: compound each full year
      double base = amount;
      for (int i = 0; i < fullYears; i++) {
        base = base + base * (rate / 100) * 12;
      }
      compoundYears.value     = fullYears;
      baseAfterCompound.value = base;

      // Step 2: simple interest on remaining months + days
      final remainderInterest = base * (rate / 100) * tRem;

      // Step 3: totals
      totalInterest = (base - amount) + remainderInterest;
      total         = amount + totalInterest;
    }

    interestAmount.value = totalInterest;
    totalAmount.value    = total;
    balance.value        = (total - paid).clamp(0, double.infinity);
    changeAmount.value   = (paid  - total).clamp(0, double.infinity);
    intsPerMonth.value   = amount * (rate / 100);
    intsPerDay.value     = intsPerMonth.value / dpm;
  }

  void reset() {
    startDate.value      = DateTime.now();
    endDate.value        = DateTime.now();
    amountController.clear();
    rateController.clear();
    paidController.clear();
    dayMode.value        = 30;
    snap1530.value       = false;
    compoundYearly.value = false;
    _recalculateDuration();
    calculate();
  }
}