import 'dart:convert';

import 'package:equatable/equatable.dart';

class CurrentUserModel extends Equatable {
  final String unit;
  final String name;
  final String monthlyRate;
  final String wifi;
  final String? mobileNo;
  final String? email;
  final String startDate;

  const CurrentUserModel({
    required this.unit,
    required this.name,
    required this.monthlyRate,
    required this.wifi,
    required this.mobileNo,
    required this.email,
    required this.startDate,
  });

  factory CurrentUserModel.fromMap(Map<String, dynamic> data) =>
      CurrentUserModel(
        unit: data['unit'] as String,
        name: data['name'] as String,
        monthlyRate: data['monthly_rate'] as String,
        wifi: data['wifi'] as String,
        mobileNo: data['mobileNo'] as String?,
        email: data['email'] as String?,
        startDate: data['start_date'] as String,
      );

  Map<String, dynamic> toMap() => {
    'unit': unit,
    'name': name,
    'monthly_rate': monthlyRate,
    'wifi': wifi,
    'mobileNo': mobileNo,
    'email': email,
    'start_date': startDate,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CurrentUserModel].
  factory CurrentUserModel.fromJson(String data) {
    return CurrentUserModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CurrentUserModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CurrentUserModel copyWith({
    String? unit,
    String? name,
    String? monthlyRate,
    String? wifi,
    String? mobileNo,
    String? email,
    String? startDate,
  }) {
    return CurrentUserModel(
      unit: unit ?? this.unit,
      name: name ?? this.name,
      monthlyRate: monthlyRate ?? this.monthlyRate,
      wifi: wifi ?? this.wifi,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [unit, name, monthlyRate, wifi, mobileNo, email, startDate];
  }
}
