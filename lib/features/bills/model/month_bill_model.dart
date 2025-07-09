import 'dart:convert';

import 'package:equatable/equatable.dart';

class MonthBillModel extends Equatable {
  final String? unit;
  final String? id;
  final String? rMonth;
  final String? rYear;
  final String? eTotal;
  final String? eRate;
  final String? wTotal;
  final String? wRate;
  final String? paid;
  final String? monthlyRate;
  final String? wifi;
  final String? date;
  final String? balance;
  final String? datePaid;
  final String? totalDue;

  const MonthBillModel({
    this.unit,
    this.id,
    this.rMonth,
    this.rYear,
    this.eTotal,
    this.eRate,
    this.wTotal,
    this.wRate,
    this.paid,
    this.monthlyRate,
    this.wifi,
    this.date,
    this.balance,
    this.datePaid,
    this.totalDue,
  });

  factory MonthBillModel.fromMap(Map<String, dynamic> data) => MonthBillModel(
    unit: data['unit'] as String?,
    id: data['id'] as String?,
    rMonth: data['rMonth'] as String?,
    rYear: data['rYear'] as String?,
    eTotal: data['eTotal'] as String?,
    eRate: data['eRate'] as String?,
    wTotal: data['wTotal'] as String?,
    wRate: data['wRate'] as String?,
    paid: data['paid'] as String?,
    monthlyRate: data['monthlyRate'] as String?,
    wifi: data['wifi'] as String?,
    date: data['date'] as String?,
    balance: data['balance'] as String?,
    datePaid: data['date_paid'] as String?,
    totalDue: data['totalDue'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'unit': unit,
    'id': id,
    'rMonth': rMonth,
    'rYear': rYear,
    'eTotal': eTotal,
    'eRate': eRate,
    'wTotal': wTotal,
    'wRate': wRate,
    'paid': paid,
    'monthlyRate': monthlyRate,
    'wifi': wifi,
    'date': date,
    'balance': balance,
    'date_paid': datePaid,
    'totalDue': totalDue,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MonthBillModel].
  factory MonthBillModel.fromJson(String data) {
    return MonthBillModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MonthBillModel] to a JSON string.
  String toJson() => json.encode(toMap());

  MonthBillModel copyWith({
    String? unit,
    String? id,
    String? rMonth,
    String? rYear,
    String? eTotal,
    String? eRate,
    String? wTotal,
    String? wRate,
    String? paid,
    String? monthlyRate,
    String? wifi,
    String? date,
    String? balance,
    String? datePaid,
    String? totalDue,
  }) {
    return MonthBillModel(
      unit: unit ?? this.unit,
      id: id ?? this.id,
      rMonth: rMonth ?? this.rMonth,
      rYear: rYear ?? this.rYear,
      eTotal: eTotal ?? this.eTotal,
      eRate: eRate ?? this.eRate,
      wTotal: wTotal ?? this.wTotal,
      wRate: wRate ?? this.wRate,
      paid: paid ?? this.paid,
      monthlyRate: monthlyRate ?? this.monthlyRate,
      wifi: wifi ?? this.wifi,
      date: date ?? this.date,
      balance: balance ?? this.balance,
      datePaid: datePaid ?? this.datePaid,
      totalDue: totalDue ?? this.totalDue,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      unit,
      id,
      rMonth,
      rYear,
      eTotal,
      eRate,
      wTotal,
      wRate,
      paid,
      monthlyRate,
      wifi,
      date,
      balance,
      datePaid,
      totalDue,
    ];
  }
}
