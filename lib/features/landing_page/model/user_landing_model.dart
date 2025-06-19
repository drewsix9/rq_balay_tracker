class UserLandingModel {
  String? unit;
  String? name;
  String? monthlyRate;
  String? wifi;
  String? mobileNo;
  String? email;
  String? startDate;

  UserLandingModel({
    this.unit,
    this.name,
    this.monthlyRate,
    this.wifi,
    this.mobileNo,
    this.email,
    this.startDate,
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
