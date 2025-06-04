import 'dart:convert';

import 'package:equatable/equatable.dart';

class CurrentUser extends Equatable {
  final String? unit;

  const CurrentUser({this.unit});

  factory CurrentUser.fromMap(Map<String, dynamic> data) =>
      CurrentUser(unit: data['unit'] as String?);

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
