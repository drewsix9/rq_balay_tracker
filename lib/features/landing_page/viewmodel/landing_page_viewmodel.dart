import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import '../model/user_landing_model.dart';

class LandingPageViewModel {
  // Fake user data
  final UserLandingModel user = UserLandingModel(
    unit: '3',
    name: 'Tita Caryl',
    monthlyRate: '3800.00',
    wifi: 'Y',
    mobileNo: '09287708266',
    email: '',
    startDate: '2022-11-03',
  );

  // Generate fake chart data for 15-min intervals (96 points for 24 hours)
  List<FlSpot> get chartData {
    final random = Random();
    List<FlSpot> spots = [];
    for (int i = 0; i < 96; i++) {
      // More random kWh values between 2.0 and 4.5
      double y = 2.0 + random.nextDouble() * 2.5;
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  // Generate time labels for x axis
  List<String> get timeLabels {
    List<String> labels = [];
    for (int i = 0; i < 96; i++) {
      int hour = (i * 15) ~/ 60;
      int minute = (i * 15) % 60;
      labels.add(
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
      );
    }
    return labels;
  }
}
