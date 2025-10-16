import 'package:fit_mind/res/animations/fade_animations.dart';
import 'package:fit_mind/res/animations/slide_animations.dart';
import 'package:fit_mind/view/health_dashboard/health_dashboard.dart';
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
                icon:  Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black,),
              ),
              const SizedBox(height: 20),

              FadeAnimations(
                delay: 0.2,
                  child: Text('Permissions', style: AppTextStyles.headingMedium)),
              const SizedBox(height: 8),
              FadeAnimations(
                delay: 0.4,
                  child: Text('Allow health data access', style: AppTextStyles.bodyLarge)),
              const SizedBox(height: 30),

              Center(
                child: FadeAnimations(
                  delay: 0.4,
                    child: Image(image: AssetImage(AppAssets.appLogo,), height: 150,)),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HealthDashboardScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
