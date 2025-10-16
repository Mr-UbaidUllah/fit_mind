import 'package:fit_mind/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fit_mind/res/animations/fade_animations.dart';
import 'package:fit_mind/res/animations/slide_animations.dart';
import 'package:fit_mind/view_model/on_boarding_view_model.dart';
import '../../core/theme/text_style.dart';
import '../../data/models/goal_model.dart';
import 'permission_screen.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnBoardingProvider>(context);

    // List of goals (using GoalModel)
    final List<GoalModel> goals = [
      GoalModel(title: 'Lose weight', icon: Icons.water_drop),
      GoalModel(title: 'Stay active', icon: Icons.directions_run),
      GoalModel(title: 'Sleep better', icon: Icons.nightlight_round),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 10),
                // Heading
                FadeAnimations(
                  delay: 0.2,
                  child: Text("Goals", style: AppTextStyles.headingLarge),
                ),
                const SizedBox(height: 8),

                // Subheading
                FadeAnimations(
                  delay: 0.4,
                  child: Text(
                    "What do you want to achieve?",
                    style: AppTextStyles.bodyMedium,
                  ),
                ),

                const SizedBox(height: 20),

                // Goal Options
                ...goals.map((goal) {
                  final bool isSelected =
                      provider.selectedGoal?.title == goal.title;

                  return SlideAnimations(
                    child: GestureDetector(
                      onTap: () => provider.selectGoal(goal),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade50
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              goal.icon,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              goal.title,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: isSelected
                                    ? Colors.blue.shade900
                                    : Colors.black87,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

               SizedBox(height: 170,),
                // Next Button
                ElevatedButton(
                  onPressed: provider.hasSelectedGoal
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PermissionScreen(),
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Next", style: AppTextStyles.buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
