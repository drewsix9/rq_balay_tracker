import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'month_bill_model.dart';

class TransactionHistoryModel extends Equatable {
  final List<MonthBillModel>? transactionHistory;

  const TransactionHistoryModel({this.transactionHistory});

  factory TransactionHistoryModel.fromMap(Map<String, dynamic> map) {
    return TransactionHistoryModel(
      transactionHistory:
          map['result'] != null
              ? List<MonthBillModel>.from(
                map['result']?.map((x) => MonthBillModel.fromMap(x)),
              )
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionHistory': transactionHistory?.map((x) => x.toMap()).toList(),
    };
  }

  factory TransactionHistoryModel.fromJson(String source) {
    return TransactionHistoryModel.fromMap(json.decode(source));
  }

  String toJson() => json.encode(toMap());

  TransactionHistoryModel copyWith({List<MonthBillModel>? transactionHistory}) {
    return TransactionHistoryModel(
      transactionHistory: transactionHistory ?? this.transactionHistory,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [transactionHistory];
}
