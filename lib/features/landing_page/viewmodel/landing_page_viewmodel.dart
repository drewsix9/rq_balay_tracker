import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:rq_balay_tracker/features/landing_page/model/hourly_kwh_consump_model/hourly_kwh_consump_model.dart';

import '../../../core/services/api_service.dart';
import '../../../core/usecases/hourly_kwh_consum_shared_pref.dart';
import '../model/daily_kwh_consump_model/daily_kwh_consump_model.dart';
import '../model/hourly_kwh_consump_model/reading_pair_model.dart';

class LandingPageViewModel extends ChangeNotifier {
  bool _isHourlyView = true;
  bool _isLoading = false;
  HourlyKwhConsumpModel _hourlyKWhConsumpList = HourlyKwhConsumpModel();
  DailyKwhConsumpModel _dailyKWhConsumpList = DailyKwhConsumpModel();
  List<ReadingPair> _readingPairs = [];
  double _yDailyMaxKWh = 0;
  double _yHourlyMaxKWh = 0;

  HourlyKwhConsumpModel get todayKWhConsumpList => _hourlyKWhConsumpList;
  DailyKwhConsumpModel get dailyKWhConsumpList => _dailyKWhConsumpList;
  List<ReadingPair> get readingPairs => _readingPairs;
  bool get isLoading => _isLoading;
  bool get isToday => _isHourlyView;
  double get yDailyMaxKWh => _yDailyMaxKWh;
  double get yHourlyMaxKWh => _yHourlyMaxKWh;

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
    _isLoading = true;
    notifyListeners();
    final todayKWhConsump = await ApiService.getTodaykWhConsump(unit: unit!);
    _hourlyKWhConsumpList = HourlyKwhConsumpModel.fromMap(todayKWhConsump!);
    await HourlyKwhConsumSharedPref.saveHourlyKwhConsum(_hourlyKWhConsumpList);
    _readingPairs = ReadingPair.generateReadingPair(_hourlyKWhConsumpList)!;
    _isLoading = false;
    notifyListeners();
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
    for (int i = 0; i < _readingPairs.length; i++) {
      // Convert to Wh
      double y = double.parse(_readingPairs[i].cumulativeEnergy) * 1000;
      _yHourlyMaxKWh = max(y, _yHourlyMaxKWh);
      spots.add(FlSpot(i.toDouble(), y));
    }

    return spots;
  }

  List<FlSpot> get dailyChartData {
    List<FlSpot> spots = [];
    for (int i = 0; i < _dailyKWhConsumpList.dailyKwhConsump!.length - 1; i++) {
      double y =
          double.parse(
            _dailyKWhConsumpList.dailyKwhConsump?[i].dailyConsumptionKwh ?? '0',
          ) *
          1000;
      _yDailyMaxKWh = max(y, _yDailyMaxKWh);
      spots.add(FlSpot(i.toDouble(), y));
    }
    return spots;
  }

  // Generate time labels for x axis
  List<String> get todayTimeLabels {
    List<String> labels = [];
    for (int i = 0; i < _readingPairs.length; i++) {
      String time = _readingPairs[i].currentReadingTs;
      labels.add(time.split(' ')[1]);
    }

    return labels;
  }

  List<String> get dailyTimeLabels {
    List<String> labels = [];
    for (int i = 0; i < _dailyKWhConsumpList.dailyKwhConsump!.length - 1; i++) {
      String dayName = _dailyKWhConsumpList.dailyKwhConsump?[i].dayName ?? '';
      String day = _dailyKWhConsumpList.dailyKwhConsump?[i].day ?? '';
      labels.add('$dayName, $day');
    }
    return labels;
  }
}
