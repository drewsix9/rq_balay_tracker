import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'today_k_wh_consump.dart';

class HourlyKwhConsumpModel extends Equatable {
  final List<TodayKWhConsump>? todayKWhConsump;

  const HourlyKwhConsumpModel({this.todayKWhConsump});

  factory HourlyKwhConsumpModel.fromMap(Map<String, dynamic> data) {
    return HourlyKwhConsumpModel(
      todayKWhConsump:
          (data['todayKWhConsump'] as List<dynamic>?)
              ?.map((e) => TodayKWhConsump.fromMap(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'todayKWhConsump': todayKWhConsump?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [HourlyKwhConsumpModel].
  factory HourlyKwhConsumpModel.fromJson(String data) {
    return HourlyKwhConsumpModel.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [HourlyKwhConsumpModel] to a JSON string.
  String toJson() => json.encode(toMap());

  HourlyKwhConsumpModel copyWith({List<TodayKWhConsump>? todayKWhConsump}) {
    return HourlyKwhConsumpModel(
      todayKWhConsump: todayKWhConsump ?? this.todayKWhConsump,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [todayKWhConsump];
}
