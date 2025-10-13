import 'package:fit_mind/view/on_boarding/permission_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/text_style.dart';
import '../../widgets/my_reusable_button.dart';


class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  String? selectedGoal;

  final List<Map<String, dynamic>> goals = [
    {'icon': Icons.water_drop, 'label': 'Lose weight'},
    {'icon': Icons.directions_run, 'label': 'Stay active'},
    {'icon': Icons.nightlight_round, 'label': 'Sleep better'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
              const SizedBox(height: 8),

              Text('Goals', style: AppTextStyles.headingMedium),
              const SizedBox(height: 8),
              Text('What do you want to achieve?',
                  style: AppTextStyles.bodyLarge),
              const SizedBox(height: 20),

              // Animation at top
              // Center(
              //   child: Lottie.asset(AppAssets.goalAnimation, height: 140),
              // ),
              const SizedBox(height: 16),

              ...goals.map((goal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() {
                    selectedGoal = goal['label'];
                  }),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedGoal == goal['label']
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedGoal == goal['label']
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Icon(goal['icon'], color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text(goal['label'], style: AppTextStyles.bodyLarge),
                      ],
                    ),
                  ),
                ),
              )),
              const Spacer(),
              MyButton(
                text: "Next",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
