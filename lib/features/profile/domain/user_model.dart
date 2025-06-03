// lib/features/profile/domain/user_model.dart
class UserModel {
  final String roomNumber;
  final String name;
  final String phoneNumber;
  final String email;

  UserModel({
    required this.roomNumber,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      roomNumber: json['roomNumber'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }
}
