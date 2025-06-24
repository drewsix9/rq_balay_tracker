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

    // Sort readings by timestamp
    final sortedReadings = List.of(readings)
      ..sort((a, b) => (a.timestamp ?? '').compareTo(b.timestamp ?? ''));

    // Helper to get minutes from timeDisplay ("HH:mm")
    int getMinutes(String? timeDisplay) {
      if (timeDisplay == null) return 0;
      final parts = timeDisplay.split(":");
      if (parts.length != 2) return 0;
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }

    // Helper to format minutes back to HH:mm
    String formatMinutes(int minutes) {
      int hours = minutes ~/ 60;
      int mins = minutes % 60;
      return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
    }

    // Create strict 15-minute intervals (00:00, 00:15, 00:30, 00:45, 01:00, etc.)
    List<int> intervals = [];
    for (int i = 0; i <= 24 * 60; i += 15) {
      intervals.add(i);
    }

    // Find readings for each 15-minute interval
    int readingIndex = 0;
    for (int i = 0; i < intervals.length - 1; i++) {
      int currentInterval = intervals[i];
      int nextInterval = intervals[i + 1];

      // Find the last reading within this 15-minute interval
      int? intervalEndIndex;
      while (readingIndex < sortedReadings.length) {
        final reading = sortedReadings[readingIndex];
        int readingMinutes = getMinutes(reading.timeDisplay);

        // If reading is within current interval, update the end index
        if (readingMinutes >= currentInterval &&
            readingMinutes < nextInterval) {
          intervalEndIndex = readingIndex;
          readingIndex++;
        } else if (readingMinutes >= nextInterval) {
          // Reading is in next interval, stop searching
          break;
        } else {
          // Reading is before current interval, skip
          readingIndex++;
        }
      }

      // If we found a reading in this interval and have a previous reading
      if (intervalEndIndex != null && intervalEndIndex > 0) {
        final prevReading = sortedReadings[intervalEndIndex - 1];
        final currReading = sortedReadings[intervalEndIndex];

        double prevEnergy = double.parse(prevReading.cumulativeEnergy ?? '0');
        double currEnergy = double.parse(currReading.cumulativeEnergy ?? '0');
        double energyDiff = currEnergy - prevEnergy;

        AppLogger.w(
          'Interval ${formatMinutes(currentInterval)}-${formatMinutes(nextInterval)}: '
          '$currEnergy - $prevEnergy = $energyDiff (${currReading.timestamp})',
        );

        readingPairs.add(
          ReadingPair(
            prevReadingTs: prevReading.timestamp ?? '',
            currentReadingTs: currReading.timestamp ?? '',
            cumulativeEnergy: energyDiff.toString(),
            timeDisplay: formatMinutes(
              currentInterval,
            ), // Use interval start time
          ),
        );
      }
    }

    if (readingPairs.isNotEmpty) {
      ListReadingPairSharedPref.saveListReadingPair(readingPairs);
      return readingPairs;
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
