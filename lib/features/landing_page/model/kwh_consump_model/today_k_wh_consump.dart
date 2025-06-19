import 'dart:convert';

import 'package:equatable/equatable.dart';

class TodayKWhConsump extends Equatable {
  final String? timestamp;
  final String? macAddress;
  final String? cumulativeEnergy;
  final String? instantaneousPower;
  final String? voltage;
  final String? current;
  final String? consumptionKwh;
  final String? minutesElapsed;
  final String? powerRateKw;
  final String? timeDisplay;
  final String? end;

  const TodayKWhConsump({
    this.timestamp,
    this.macAddress,
    this.cumulativeEnergy,
    this.instantaneousPower,
    this.voltage,
    this.current,
    this.consumptionKwh,
    this.minutesElapsed,
    this.powerRateKw,
    this.timeDisplay,
    this.end,
  });

  factory TodayKWhConsump.fromMap(Map<String, dynamic> data) {
    return TodayKWhConsump(
      timestamp: data['timestamp'] as String?,
      macAddress: data['mac_address'] as String?,
      cumulativeEnergy: data['cumulative_energy'] as String?,
      instantaneousPower: data['instantaneous_power'] as String?,
      voltage: data['voltage'] as String?,
      current: data['current'] as String?,
      consumptionKwh: data['consumption_kwh'] as String?,
      minutesElapsed: data['minutes_elapsed'] as String?,
      powerRateKw: data['power_rate_kw'] as String?,
      timeDisplay: data['time_display'] as String?,
      end: data['end'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp,
    'mac_address': macAddress,
    'cumulative_energy': cumulativeEnergy,
    'instantaneous_power': instantaneousPower,
    'voltage': voltage,
    'current': current,
    'consumption_kwh': consumptionKwh,
    'minutes_elapsed': minutesElapsed,
    'power_rate_kw': powerRateKw,
    'time_display': timeDisplay,
    'end': end,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TodayKWhConsump].
  factory TodayKWhConsump.fromJson(String data) {
    return TodayKWhConsump.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TodayKWhConsump] to a JSON string.
  String toJson() => json.encode(toMap());

  TodayKWhConsump copyWith({
    String? timestamp,
    String? macAddress,
    String? cumulativeEnergy,
    String? instantaneousPower,
    String? voltage,
    String? current,
    String? consumptionKwh,
    String? minutesElapsed,
    String? powerRateKw,
    String? timeDisplay,
    String? end,
  }) {
    return TodayKWhConsump(
      timestamp: timestamp ?? this.timestamp,
      macAddress: macAddress ?? this.macAddress,
      cumulativeEnergy: cumulativeEnergy ?? this.cumulativeEnergy,
      instantaneousPower: instantaneousPower ?? this.instantaneousPower,
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      consumptionKwh: consumptionKwh ?? this.consumptionKwh,
      minutesElapsed: minutesElapsed ?? this.minutesElapsed,
      powerRateKw: powerRateKw ?? this.powerRateKw,
      timeDisplay: timeDisplay ?? this.timeDisplay,
      end: end ?? this.end,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      timestamp,
      macAddress,
      cumulativeEnergy,
      instantaneousPower,
      voltage,
      current,
      consumptionKwh,
      minutesElapsed,
      powerRateKw,
      timeDisplay,
      end,
    ];
  }
}
