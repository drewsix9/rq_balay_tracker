import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../logger/app_logger.dart';

class CurrentUser extends Equatable {
  final String? unit;
  final String? name;

  const CurrentUser({this.unit, this.name});

  factory CurrentUser.fromMap(Map<String, dynamic> data) {
    final unitValue = data['unit'];
    final nameValue = data['name'];
    String? unitString;
    String? nameString;

    if (unitValue != null) {
      if (unitValue is String) {
        unitString = unitValue.trim().isEmpty ? null : unitValue.trim();
      } else if (unitValue is num) {
        unitString = unitValue.toString();
      } else {
        unitString = unitValue.toString();
      }
    }

    if (nameValue != null) {
      if (nameValue is String) {
        nameString = nameValue.trim().isEmpty ? null : nameValue.trim();
      } else {
        nameString = nameValue.toString();
      }
    }

    AppLogger.d("Unit string: $unitString");
    AppLogger.d("Unit string type: ${unitString.runtimeType}");
    AppLogger.d("Name string: $nameString");
    AppLogger.d("Name string type: ${nameString.runtimeType}");

    return CurrentUser(unit: unitString, name: nameString);
  }

  Map<String, dynamic> toMap() => {'unit': unit, 'name': name};

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

  CurrentUser copyWith({String? unit, String? name}) {
    return CurrentUser(unit: unit ?? this.unit, name: name ?? this.name);
  }

  @override
  List<Object?> get props => [unit, name];
}
