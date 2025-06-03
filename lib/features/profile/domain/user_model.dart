// lib/features/profile/domain/user_model.dart
class UserModel {
  final String roomNumber;
  final String name;
  final int monthlyRate;
  final bool wifiEnabled;
  final String phoneNumber;
  final String email;
  final String startDate;
  final String? endDate;

  UserModel({
    required this.monthlyRate,
    required this.roomNumber,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.startDate,
    this.endDate,
    this.wifiEnabled = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      monthlyRate: json['monthlyRate'],
      roomNumber: json['roomNumber'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      startDate: json['startDate'],
      email: json['email'],
    );
  }
}
