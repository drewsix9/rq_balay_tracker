import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/api_service.dart';
import '../model/daily_kwh_consump_model/daily_kwh_consump_model.dart';
import '../model/kwh_consump_model/kwh_consump_model.dart';

class LandingPageViewModel extends ChangeNotifier {
  bool _isHourlyView = true;
  bool _isLoading = false;
  KwhConsumpModel _todayKWhConsumpList = KwhConsumpModel();
  DailyKwhConsumpModel _dailyKWhConsumpList = DailyKwhConsumpModel();

  KwhConsumpModel get todayKWhConsumpList => _todayKWhConsumpList;
  DailyKwhConsumpModel get dailyKWhConsumpList => _dailyKWhConsumpList;
  bool get isLoading => _isLoading;
  bool get isToday => _isHourlyView;

  Future<void> fakeLoading() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }

  void isHourlyViewToggle(bool isHourlyView) {
    _isHourlyView = isHourlyView;
    notifyListeners();
  }

  Future<void> getTodayKWhConsump(String? unit) async {
    final todayKWhConsump = await ApiService.getTodaykWhConsump(unit: unit!);
    _todayKWhConsumpList = KwhConsumpModel.fromMap(todayKWhConsump!);
  }

  Future<void> getDailyKWhConsump(
    String? unit, [
    String? month,
    String? year,
  ]) async {
    final now = DateTime.now();
    final monthToUse = month ?? now.month.toString().padLeft(2, '0');
    final yearToUse = year ?? now.year.toString();

    final dailyKWhConsump = await ApiService.getDailykWhConsump(
      unit: unit!,
      month: monthToUse,
      year: yearToUse,
    );
    _dailyKWhConsumpList = DailyKwhConsumpModel.fromMap(dailyKWhConsump!);
  }

  Future<void> initializeData(String? unit) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([getTodayKWhConsump(unit), getDailyKWhConsump(unit)]);
    } catch (e) {
      // Handle any errors here if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generate fake chart data for 15-min intervals (96 points for 24 hours)
  List<FlSpot> get todayChartData {
    List<FlSpot> spots = [];
    for (int i = 0; i < _todayKWhConsumpList.todayKWhConsump!.length - 1; i++) {
      double y = double.parse(
        _todayKWhConsumpList.todayKWhConsump?[i].consumptionKwh ?? '0',
      );
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  List<FlSpot> get dailyChartData {
    List<FlSpot> spots = [];
    for (int i = 0; i < _dailyKWhConsumpList.dailyKwhConsump!.length - 1; i++) {
      double y = double.parse(
        _dailyKWhConsumpList.dailyKwhConsump?[i].dailyConsumptionKwh ?? '0',
      );
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  // Generate time labels for x axis
  List<String> get todayTimeLabels {
    List<String> labels = [];
    for (var element in _todayKWhConsumpList.todayKWhConsump ?? []) {
      labels.add(element.timeDisplay ?? '');
    }

    return labels;
  }

  List<String> get dailyTimeLabels {
    List<String> labels = [];
    for (var element in _dailyKWhConsumpList.dailyKwhConsump ?? []) {
      labels.add(element.day ?? '');
    }
    return labels;
  }
}
