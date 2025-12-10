import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mind/view/home/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/google_fit_view_model.dart';
import '../../view_model/on_boarding_view_model.dart';

import '../../data/models/goal_model.dart';
import '../ai_coach/ai_coach_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // Fetch all data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HealthViewModel>(context, listen: false).fetchHealthData();
      Provider.of<OnBoardingProvider>(context, listen: false).loadSavedGoal();
      Provider.of<OnBoardingProvider>(context, listen: false).loadSavedMood();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<OnBoardingProvider>(context);
    final healthProvider = Provider.of<HealthViewModel>(context);
    final user = FirebaseAuth.instance.currentUser;

    final String currentGoal = goalProvider.selectedGoal?.title ?? "Stay Healthy";
    final IconData currentIcon = goalProvider.selectedGoal?.icon ?? Icons.favorite;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello,", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              user?.displayName ?? "User",
              style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blueAccent),
            onPressed: () => healthProvider.fetchHealthData(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await healthProvider.fetchHealthData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. MOOD TRACKER
              _buildSectionTitle("How are you feeling?"),
              _buildMoodTracker(goalProvider),

              const SizedBox(height: 15),

              // Dynamic Insight Text (Shows only if mood is selected)
              if (goalProvider.currentMood.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Here's some motivation for your mood...",
                    style: TextStyle(color: Colors.blue.shade700, fontStyle: FontStyle.italic),
                  ),
                ),

              const SizedBox(height: 20),

              // 2. GOAL BANNER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildGoalBanner(context, currentGoal, currentIcon),
              ),

              const SizedBox(height: 25),

              // 3. AI COACH CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAICoachCard(context),
              ),

              const SizedBox(height: 25),

              // 4. HEALTH STATS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _HealthStatCard(
                        title: "Steps",
                        value: healthProvider.steps.toStringAsFixed(0),
                        icon: Icons.directions_walk,
                        color: Colors.orangeAccent,
                        progress: (healthProvider.steps / 10000).clamp(0.0, 1.0),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _HealthStatCard(
                        title: "Heart Rate",
                        value: healthProvider.heartRate.toStringAsFixed(0),
                        icon: Icons.favorite,
                        color: Colors.redAccent,
                        progress: null,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 5. MOTIVATIONAL QUOTE
              _buildSectionTitle("Daily Motivation"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildQuoteCard(goalProvider.dailyQuote),
              ),

              const SizedBox(height: 30),

              // 6. RECOMMENDED TIPS CAROUSEL
              _buildSectionTitle("Recommended for You"),
              SizedBox(
                height: 130, // Fixed height for horizontal list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: goalProvider.recommendedTips.length,
                  itemBuilder: (context, index) {
                    return _buildMiniTipCard(goalProvider.recommendedTips[index], index);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMoodTracker(OnBoardingProvider provider) {
    final moods = ["😫", "😐", "🙂", "😃", "🔥"];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = provider.currentMood == mood;

          return GestureDetector(
            onTap: () => provider.setMood(mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Text(
                mood,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAICoachCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AICoachScreen()));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AI Fitness Coach",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Chat now for workouts & diet tips",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard(String quote) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote_rounded, color: Colors.orange, size: 36),
          const SizedBox(height: 10),
          Text(
            quote,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.orange.shade900,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalBanner(BuildContext context, String goal, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Current Focus",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => _showChangeGoalBottomSheet(context),
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: "Change Goal",
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTipCard(String tip, int index) {
    final colors = [Colors.blue.shade50, Colors.green.shade50, Colors.purple.shade50];
    final textColors = [Colors.blue.shade900, Colors.green.shade900, Colors.purple.shade900];
    final color = colors[index % colors.length];
    final textColor = textColors[index % textColors.length];

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Tip #${index + 1}",
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            tip,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showChangeGoalBottomSheet(BuildContext context) {
    final provider = Provider.of<OnBoardingProvider>(context, listen: false);
    final goals = [
      GoalModel(title: 'Lose weight', icon: Icons.water_drop),
      GoalModel(title: 'Stay active', icon: Icons.directions_run),
      GoalModel(title: 'Sleep better', icon: Icons.nightlight_round),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Change Goal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...goals.map((g) => ListTile(
              leading: Icon(g.icon, color: Colors.blue),
              title: Text(g.title),
              onTap: () { provider.selectGoal(g); Navigator.pop(context); },
            )),
          ],
        ),
      ),
    );
  }
}

class _HealthStatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  final double? progress;

  const _HealthStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
            ],
          ),
          const SizedBox(height: 15),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ]
        ],
      ),
    );
  }
}