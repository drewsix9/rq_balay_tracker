import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'daily_kwh_consump.dart';

class DailyKwhConsumpModel extends Equatable {
  final List<DailyKwhConsump>? dailyKwhConsump;

  const DailyKwhConsumpModel({this.dailyKwhConsump});

  factory DailyKwhConsumpModel.fromMap(Map<String, dynamic> data) {
    return DailyKwhConsumpModel(
      dailyKwhConsump:
          (data['dailyKwhConsump'] as List<dynamic>?)
              ?.map((e) => DailyKwhConsump.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'dailyKwhConsump': dailyKwhConsump?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DailyKwhConsumpModel].
  factory DailyKwhConsumpModel.fromJson(String data) {
    return DailyKwhConsumpModel.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [DailyKwhConsumpModel] to a JSON string.
  String toJson() => json.encode(toMap());

  DailyKwhConsumpModel copyWith({List<DailyKwhConsump>? dailyKwhConsump}) {
    return DailyKwhConsumpModel(
      dailyKwhConsump: dailyKwhConsump ?? this.dailyKwhConsump,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [dailyKwhConsump];
}
