import 'dart:convert';

import 'package:equatable/equatable.dart';

class DailyKwhConsump extends Equatable {
  final String? date;
  final String? macAddress;
  final String? firstReadingTime;
  final String? firstReadingValue;
  final String? lastReadingTime;
  final String? lastReadingValue;
  final String? dailyConsumptionKwh;
  final String? day;
  final String? dayName;
  final String? monthName;

  const DailyKwhConsump({
    this.date,
    this.macAddress,
    this.firstReadingTime,
    this.firstReadingValue,
    this.lastReadingTime,
    this.lastReadingValue,
    this.dailyConsumptionKwh,
    this.day,
    this.dayName,
    this.monthName,
  });

  factory DailyKwhConsump.fromMap(Map<String, dynamic> data) {
    return DailyKwhConsump(
      date: data['date'] as String?,
      macAddress: data['mac_address'] as String?,
      firstReadingTime: data['first_reading_time'] as String?,
      firstReadingValue: data['first_reading_value'] as String?,
      lastReadingTime: data['last_reading_time'] as String?,
      lastReadingValue: data['last_reading_value'] as String?,
      dailyConsumptionKwh: data['daily_consumption_kwh'] as String?,
      day: data['day'] as String?,
      dayName: data['day_name'] as String?,
      monthName: data['month_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'date': date,
    'mac_address': macAddress,
    'first_reading_time': firstReadingTime,
    'first_reading_value': firstReadingValue,
    'last_reading_time': lastReadingTime,
    'last_reading_value': lastReadingValue,
    'daily_consumption_kwh': dailyConsumptionKwh,
    'day': day,
    'day_name': dayName,
    'month_name': monthName,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DailyKwhConsump].
  factory DailyKwhConsump.fromJson(String data) {
    return DailyKwhConsump.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DailyKwhConsump] to a JSON string.
  String toJson() => json.encode(toMap());

  DailyKwhConsump copyWith({
    String? date,
    String? macAddress,
    String? firstReadingTime,
    String? firstReadingValue,
    String? lastReadingTime,
    String? lastReadingValue,
    String? dailyConsumptionKwh,
    String? day,
    String? dayName,
    String? monthName,
  }) {
    return DailyKwhConsump(
      date: date ?? this.date,
      macAddress: macAddress ?? this.macAddress,
      firstReadingTime: firstReadingTime ?? this.firstReadingTime,
      firstReadingValue: firstReadingValue ?? this.firstReadingValue,
      lastReadingTime: lastReadingTime ?? this.lastReadingTime,
      lastReadingValue: lastReadingValue ?? this.lastReadingValue,
      dailyConsumptionKwh: dailyConsumptionKwh ?? this.dailyConsumptionKwh,
      day: day ?? this.day,
      dayName: dayName ?? this.dayName,
      monthName: monthName ?? this.monthName,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      date,
      macAddress,
      firstReadingTime,
      firstReadingValue,
      lastReadingTime,
      lastReadingValue,
      dailyConsumptionKwh,
      day,
      dayName,
      monthName,
    ];
  }
}
