import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../logger/app_logger.dart';

class CurrentUser extends Equatable {
  final String? unit;

  const CurrentUser({this.unit});

  factory CurrentUser.fromMap(Map<String, dynamic> data) {
    // Debug the incoming data
    AppLogger.d("Incoming data: $data");
    AppLogger.d("Incoming data type: ${data.runtimeType}");

    // Try different possible keys
    final unit = data['unit'] ?? data['Unit'] ?? data['UNIT'];
    AppLogger.d("Unit: $unit");
    AppLogger.d("Unit type: ${unit.runtimeType}");

    // Handle different possible types
    String? unitString;
    if (unit != null) {
      if (unit is String) {
        unitString = unit;
      } else if (unit is num) {
        unitString = unit.toString();
      }
    }

    return CurrentUser(unit: unitString);
  }

  Map<String, dynamic> toMap() => {'unit': unit};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CurrentUser].
  factory CurrentUser.fromJson(String data) {
    return CurrentUser.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CurrentUser] to a JSON string.
  String toJson() => json.encode(toMap());

  CurrentUser copyWith({String? unit}) {
    return CurrentUser(unit: unit ?? this.unit);
  }

  @override
  List<Object?> get props => [unit];
}
