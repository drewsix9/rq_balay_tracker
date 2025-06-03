// lib/features/profile/presentation/profile_provider.dart
import 'package:flutter/foundation.dart';
import 'package:rq_balay_tracker/features/profile/domain/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
