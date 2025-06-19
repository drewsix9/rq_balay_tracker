import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/services/api_service.dart';
import '../model/kwh_consump_model/kwh_consump_model.dart';
import '../model/user_landing_model.dart';

class LandingPageViewModel extends ChangeNotifier {
  bool _isLoading = false;
  KwhConsumpModel _todayKWhConsumpList = KwhConsumpModel();

  KwhConsumpModel get todayKWhConsumpList => _todayKWhConsumpList;
  bool get isLoading => _isLoading;

  Future<void> getTodayKWhConsump(String? unit) async {
    _isLoading = true;
    notifyListeners();
    final todayKWhConsump = await ApiService.getTodaykWhConsump(unit: unit!);
    _todayKWhConsumpList = KwhConsumpModel.fromMap(todayKWhConsump!);
    _isLoading = false;
    notifyListeners();
    for (var element in _todayKWhConsumpList.todayKWhConsump ?? []) {
      AppLogger.d("Element: ${element.timeDisplay}\n${element.consumptionKwh}");
    }
  }

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
    List<FlSpot> spots = [];
    for (int i = 0; i < _todayKWhConsumpList.todayKWhConsump!.length; i++) {
      double y = double.parse(
        _todayKWhConsumpList.todayKWhConsump?[i].consumptionKwh ?? '0',
      );
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  // Generate time labels for x axis
  List<String> get timeLabels {
    List<String> labels = [];
    for (var element in _todayKWhConsumpList.todayKWhConsump ?? []) {
      labels.add(element.timeDisplay ?? '');
    }

    return labels;
  }
}
