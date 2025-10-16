import 'package:flutter/material.dart';
import '../data/services/google_fit_services.dart';


class GoogleFitProvider with ChangeNotifier {
  final GoogleFitService _googleFitService = GoogleFitService();

  bool _isLoading = false;
  bool _hasPermission = false;
  double _steps = 0;
  double _heartRate = 0;

  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  double get steps => _steps;
  double get heartRate => _heartRate;

  /// Request permissions
  Future<void> requestPermissions() async {
    _isLoading = true;
    notifyListeners();

    _hasPermission = await _googleFitService.requestPermissions();
    _isLoading = false;
    notifyListeners();
  }

  /// Fetch the latest health data
  Future<void> fetchHealthData() async {
    if (!_hasPermission) {
      _hasPermission = await _googleFitService.hasPermissions();
      if (!_hasPermission) return;
    }

    _isLoading = true;
    notifyListeners();

    final data = await _googleFitService.fetchHealthData();
    _steps = (data['steps'] ?? 0).toDouble();
    _heartRate = (data['heartRate'] ?? 0).toDouble();

    _isLoading = false;
    notifyListeners();
  }
}
