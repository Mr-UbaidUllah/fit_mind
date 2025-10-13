import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/text_style.dart';
import '../../widgets/my_reusable_button.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

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

              Text('Permissions', style: AppTextStyles.headingMedium),
              const SizedBox(height: 8),
              Text('Allow health data access', style: AppTextStyles.bodyLarge),
              const SizedBox(height: 30),

              Center(
                child: Lottie.asset(AppAssets.googleFitAnimation, height: 180),
              ),
              const SizedBox(height: 24),

              Text(
                'To track your steps and heart rate, enable access to Google Fit health data.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),

              const Spacer(),
              MyButton(
                text: "Connect to Google Fit",
                onPressed: () {
                  // TODO: connect with Google Fit service
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
