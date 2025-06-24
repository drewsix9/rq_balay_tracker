import 'dart:convert';

import 'package:rq_balay_tracker/features/landing_page/model/hourly_kwh_consump_model/hourly_kwh_consump_model.dart';

import '../../../../core/logger/app_logger.dart';
import '../../../../core/usecases/list_reading_pair_shared_pref.dart';

class ReadingPair {
  final String prevReadingTs;
  final String currentReadingTs;
  final String cumulativeEnergy;
  final String timeDisplay;

  ReadingPair({
    required this.prevReadingTs,
    required this.currentReadingTs,
    required this.cumulativeEnergy,
    required this.timeDisplay,
  });

  @override
  String toString() {
    return 'ReadingPair(prevReadingTs: $prevReadingTs, currentReadingTs: $currentReadingTs, cumulativeEnergy: $cumulativeEnergy, timeDisplay: $timeDisplay)';
  }

  static List<ReadingPair>? generateReadingPair(
    HourlyKwhConsumpModel hourlyKwhConsump,
  ) {
    List<ReadingPair> readingPairs = [];
    final readings = hourlyKwhConsump.todayKWhConsump;
    if (readings == null || readings.length < 2) return null;

    // Sort readings by timestamp (just in case)
    final sortedReadings = List.of(readings)
      ..sort((a, b) => (a.timestamp ?? '').compareTo(b.timestamp ?? ''));

    // Helper to get minutes from timeDisplay ("HH:mm")
    int getMinutes(String? timeDisplay) {
      if (timeDisplay == null) return 0;
      final parts = timeDisplay.split(":");
      if (parts.length != 2) return 0;
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    int interval = 15; // minutes
    int prevIdx = 0;
    for (int targetMin = 0; targetMin <= 24 * 60; targetMin += interval) {
      // Find the closest reading to this targetMin
      int? closestIdx;
      int minDiff = 9999;
      for (int i = prevIdx + 1; i < sortedReadings.length; i++) {
        final r = sortedReadings[i];
        int rMin = getMinutes(r.timeDisplay);
        int diff = (rMin - targetMin).abs();
        if (diff < minDiff) {
          minDiff = diff;
          closestIdx = i;
        } else if (rMin > targetMin) {
          break;
        }
      }
      if (closestIdx != null) {
        final prev = sortedReadings[prevIdx];
        final curr = sortedReadings[closestIdx];
        double prevEnergy = double.parse(prev.cumulativeEnergy ?? '0');
        double currEnergy = double.parse(curr.cumulativeEnergy ?? '0');
        double energyDiff = currEnergy - prevEnergy;
        AppLogger.w(
          '$currEnergy - $prevEnergy = $energyDiff \\${curr.timestamp}',
        );

        readingPairs.add(
          ReadingPair(
            prevReadingTs: prev.timestamp ?? '',
            currentReadingTs: curr.timestamp ?? '',
            cumulativeEnergy: energyDiff.toString(),
            timeDisplay: curr.timeDisplay ?? '',
          ),
        );
        prevIdx = closestIdx;
      }
    }
    if (readingPairs.isNotEmpty) {
      ListReadingPairSharedPref.saveListReadingPair(readingPairs.sublist(1));
      return readingPairs.sublist(1);
    }
    return readingPairs;
  }

  Map<String, dynamic> toJson() {
    return {
      'prevReadingTs': prevReadingTs,
      'currentReadingTs': currentReadingTs,
      'cumulativeEnergy': cumulativeEnergy,
      'timeDisplay': timeDisplay,
    };
  }

  static ReadingPair fromJson(Map<String, dynamic> json) {
    return ReadingPair(
      prevReadingTs: json['prevReadingTs'] ?? '',
      currentReadingTs: json['currentReadingTs'] ?? '',
      cumulativeEnergy: json['cumulativeEnergy'] ?? '',
      timeDisplay: json['timeDisplay'] ?? '',
    );
  }

  static ReadingPair fromJsonString(String jsonString) {
    return ReadingPair.fromJson(jsonDecode(jsonString));
  }
}
