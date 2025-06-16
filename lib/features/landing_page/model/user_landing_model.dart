class UserLandingModel {
  final String unit;
  final String name;
  final String monthlyRate;
  final String wifi;
  final String mobileNo;
  final String email;
  final String startDate;

  UserLandingModel({
    required this.unit,
    required this.name,
    required this.monthlyRate,
    required this.wifi,
    required this.mobileNo,
    required this.email,
    required this.startDate,
  });

  factory UserLandingModel.fromJson(Map<String, dynamic> json) {
    return UserLandingModel(
      unit: json['unit'] ?? '',
      name: json['name'] ?? '',
      monthlyRate: json['monthly_rate'] ?? '',
      wifi: json['wifi'] ?? '',
      mobileNo: json['mobileno'] ?? '',
      email: json['email'] ?? '',
      startDate: json['start_date'] ?? '',
    );
  }
}
