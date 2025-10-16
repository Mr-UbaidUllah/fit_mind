import 'package:flutter/material.dart';


import '../data/models/goal_model.dart';

class OnBoardingProvider with ChangeNotifier {
  GoalModel? _selectedGoal;

  GoalModel? get selectedGoal => _selectedGoal;

  void selectGoal(GoalModel goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  bool get hasSelectedGoal => _selectedGoal != null;
}
