import 'package:flutter/material.dart';

import 'current_user.dart';

class CurrentUserProvider extends ChangeNotifier {
  CurrentUser? _currentUser;

  void setCurrentUser(CurrentUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  CurrentUser? get currentUser => _currentUser;
}
