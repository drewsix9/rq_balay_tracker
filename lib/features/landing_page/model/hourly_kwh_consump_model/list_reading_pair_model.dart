import 'dart:convert';

import 'package:rq_balay_tracker/features/landing_page/model/hourly_kwh_consump_model/reading_pair_model.dart';

class ListReadingPairModel {
  final List<ReadingPair> listReadingPair;

  ListReadingPairModel({required this.listReadingPair});

  factory ListReadingPairModel.fromJson(String json) {
    final List<dynamic> jsonList = jsonDecode(json);
    return ListReadingPairModel(
      listReadingPair:
          jsonList
              .map((item) => ReadingPair.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }

  String toJson() {
    return jsonEncode(listReadingPair.map((e) => e.toJson()).toList());
  }
}
