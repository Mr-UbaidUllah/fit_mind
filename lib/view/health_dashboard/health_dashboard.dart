

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/google_fit_view_model.dart';

class HealthDashboardScreen extends StatelessWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fitProvider = Provider.of<GoogleFitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: fitProvider.isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!fitProvider.hasPermission)
              ElevatedButton(
                onPressed: fitProvider.requestPermissions,
                child: const Text('Grant Permissions'),
              )
            else ...[
              ElevatedButton(
                onPressed: fitProvider.fetchHealthData,
                child: const Text('Fetch Health Data'),
              ),
              const SizedBox(height: 30),
              Text(
                'Steps: ${fitProvider.steps.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Heart Rate: ${fitProvider.heartRate.toStringAsFixed(1)} bpm',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
