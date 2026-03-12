import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/interest_controller.dart';
import '../widgets/app_header.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/duration_display.dart';
import '../widgets/day_mode_selector.dart';
import '../widgets/amount_input_section.dart';
import '../widgets/result_card.dart';
import '../widgets/interest_rate_info.dart';
import '../widgets/action_buttons.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InterestController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Section
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Period', style: AppTextStyles.headingMedium),
                        const SizedBox(height: 14),
                        Obx(() => DatePickerField(
                          label: 'Start Date',
                          selectedDate: controller.startDate.value,
                          onDateSelected: controller.setStartDate,
                        )),
                        const SizedBox(height: 10),
                        Obx(() => DatePickerField(
                          label: 'End Date',
                          selectedDate: controller.endDate.value,
                          onDateSelected: controller.setEndDate,
                          firstDate: controller.startDate.value,
                        )),
                        const SizedBox(height: 14),
                        const DurationDisplay(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mode Section
                  SectionCard(
                    child: const DayModeSelector(),
                  ),
                  const SizedBox(height: 14),

                  // Inputs Section
                  SectionCard(
                    child: const AmountInputSection(),
                  ),
                  const SizedBox(height: 14),

                  // Action buttons
                  const ActionButtons(),
                  const SizedBox(height: 14),

                  // Results
                  const ResultCard(),
                  const SizedBox(height: 14),

                  // Ints per day / month
                  const InterestRateInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

