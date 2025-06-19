import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'today_k_wh_consump.dart';

class KwhConsumpModel extends Equatable {
  final List<TodayKWhConsump>? todayKWhConsump;

  const KwhConsumpModel({this.todayKWhConsump});

  factory KwhConsumpModel.fromMap(Map<String, dynamic> data) {
    return KwhConsumpModel(
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
  /// Parses the string and returns the resulting Json object as [KwhConsumpModel].
  factory KwhConsumpModel.fromJson(String data) {
    return KwhConsumpModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [KwhConsumpModel] to a JSON string.
  String toJson() => json.encode(toMap());

  KwhConsumpModel copyWith({List<TodayKWhConsump>? todayKWhConsump}) {
    return KwhConsumpModel(
      todayKWhConsump: todayKWhConsump ?? this.todayKWhConsump,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [todayKWhConsump];
}
