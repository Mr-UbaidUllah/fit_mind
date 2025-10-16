import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

class GoogleFitService {
  // Use the health package main class
  final Health _health = Health();

  // Data types for health package
  final List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
  ];

  /// Request permissions (works for health / Health Connect)
  Future<bool> requestPermissions() async {
    try {
      if (Platform.isAndroid) {
        // For Health Connect: check availability
        final bool hcAvailable = await HealthConnectFactory.isAvailable();
        if (hcAvailable) {
          return await HealthConnectFactory.requestPermissions([
            HealthConnectDataType.Steps,
            HealthConnectDataType.HeartRate,
          ]);
        }
      }

      // Fallback to health (iOS / older Android)
      return await _health.requestAuthorization(_dataTypes);
    } catch (e) {
      debugPrint("Permission request failed: $e");
      return false;
    }
  }

  /// Fetch data
  Future<Map<String, dynamic>> fetchHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    try {
      if (Platform.isAndroid) {
        final bool hcAvailable = await HealthConnectFactory.isAvailable();
        if (hcAvailable) {
          // Health Connect path (dynamic-safe parsing)
          final dynamic rawSteps = await HealthConnectFactory.getRecord(
            startTime: yesterday,
            endTime: now,
            type: HealthConnectDataType.Steps,
          );

          final dynamic rawHr = await HealthConnectFactory.getRecord(
            startTime: yesterday,
            endTime: now,
            type: HealthConnectDataType.HeartRate,
          );

          // Normalize to List<dynamic>
          final List<dynamic> stepsList =
          rawSteps is List ? rawSteps.cast<dynamic>() : [rawSteps];
          final List<dynamic> hrList =
          rawHr is List ? rawHr.cast<dynamic>() : [rawHr];

          // Sum steps robustly (handle Map or object)
          double stepSum = 0;
          for (var rec in stepsList) {
            if (rec == null) continue;

            // if record is a Map
            if (rec is Map) {
              final val = rec['count'] ?? rec['value'] ?? rec['steps'] ?? 0;
              if (val is num) {
                stepSum += val.toDouble();
              } else {
                stepSum += double.tryParse(val.toString()) ?? 0;
              }
            } else {
              // try to access properties (some versions return objects)
              try {
                final dynamic val = rec.count ?? rec.value ?? rec.steps;
                if (val is num) {
                  stepSum += val.toDouble();
                } else {
                  stepSum += double.tryParse(val?.toString() ?? '') ?? 0;
                }
              } catch (_) {
                // fallback: try toString -> parse number
                final parsed = double.tryParse(rec.toString());
                if (parsed != null) stepSum += parsed;
              }
            }
          }

          // Extract heart rate samples robustly
          List<double> hrValues = [];
          for (var rec in hrList) {
            if (rec == null) continue;

            if (rec is Map) {
              // check for 'samples' array or direct value
              final samples = rec['samples'];
              if (samples is Iterable) {
                for (var s in samples) {
                  final v = s['bpm'] ?? s['value'] ?? s['beatsPerMinute'] ?? s['heartRate'];
                  if (v is num) {
                    hrValues.add(v.toDouble());
                  } else {
                    final parsed = double.tryParse(v?.toString() ?? '');
                    if (parsed != null) hrValues.add(parsed);
                  }
                }
              } else {
                final v = rec['bpm'] ?? rec['value'] ?? rec['beatsPerMinute'] ?? rec['heartRate'];
                if (v is num) {
                  hrValues.add(v.toDouble());
                } else {
                  final parsed = double.tryParse(v?.toString() ?? '');
                  if (parsed != null) hrValues.add(parsed);
                }
              }
            } else {
              // object with properties (try common property names)
              try {
                final samples = rec.samples;
                if (samples is Iterable) {
                  for (var s in samples) {
                    var v;
                    try {
                      v = s.bpm ?? s.value ?? s.beatsPerMinute ?? s.heartRate;
                    } catch (_) {
                      // try map-like access on sample
                      try {
                        v = s['bpm'] ?? s['value'] ?? s['beatsPerMinute'] ?? s['heartRate'];
                      } catch (_) {
                        v = null;
                      }
                    }
                    if (v is num) {
                      hrValues.add(v.toDouble());
                    } else {
                      final parsed = double.tryParse(v?.toString() ?? '');
                      if (parsed != null) hrValues.add(parsed);
                    }
                  }
                } else {
                  // maybe direct value on record
                  var v;
                  try {
                    v = rec.bpm ?? rec.value ?? rec.beatsPerMinute ?? rec.heartRate;
                  } catch (_) {
                    v = null;
                  }
                  if (v is num) {
                    hrValues.add(v.toDouble());
                  } else {
                    final parsed = double.tryParse(v?.toString() ?? '');
                    if (parsed != null) hrValues.add(parsed);
                  }
                }
              } catch (_) {
                // fallback: try parse rec.toString()
                final parsed = double.tryParse(rec.toString());
                if (parsed != null) hrValues.add(parsed);
              }
            }
          }

          final double avgHr = hrValues.isEmpty
              ? 0.0
              : hrValues.reduce((a, b) => a + b) / hrValues.length;

          return {'steps': stepSum, 'heartRate': avgHr};
        }
      }

      // Fallback: health package
      final points = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.STEPS],
      );

      double steps = 0;
      double heartRate = 0;
      int hrCount = 0;
      for (var p in points) {
        if (p.type == HealthDataType.STEPS) {
          steps += (p.value as num).toDouble();
        } else if (p.type == HealthDataType.HEART_RATE) {
          heartRate += (p.value as num).toDouble();
          hrCount++;
        }
      }
      double avgHr = hrCount > 0 ? heartRate / hrCount : 0;
      return {'steps': steps, 'heartRate': avgHr};
    } catch (e) {
      debugPrint("Error fetching health data: $e");
      return {};
    }
  }

  Future<bool> hasPermissions() async {
    try {
      if (Platform.isAndroid) {
        final bool hcAvailable = await HealthConnectFactory.isAvailable();
        if (hcAvailable) {
          return await HealthConnectFactory.hasPermissions([
            HealthConnectDataType.Steps,
            HealthConnectDataType.HeartRate,
          ]);
        }
      }
      return await _health.hasPermissions(_dataTypes) ?? false;
    } catch (e) {
      debugPrint("hasPermissions error: $e");
      return false;
    }
  }
}
