import 'package:flutter/foundation.dart';

import '../../features/bills/data/month_bill.dart';
import '../global/current_user.dart';
import '../logger/app_logger.dart';
import '../services/api_service.dart';
import '../usecases/month_bill_shared_pref.dart';
import '../usecases/unit_shared_pref.dart';
import '../usecases/user_shared_pref.dart';

class BillsProvider with ChangeNotifier {
  String? _currentUnit;
  CurrentUserModel? _currentUser;
  MonthBillModel? _currentBill;
  bool _isLoading = false;

  String? get currentUnit => _currentUnit;
  CurrentUserModel? get currentUser => _currentUser;
  MonthBillModel? get currentBill => _currentBill;
  bool get isLoading => _isLoading;

  BillsProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await getCurrentMonthBill();
  }

  Future<void> getCurrentMonthBill() async {
    try {
      _currentUnit = await UnitSharedPref.getUnit();
      _currentUser = await UserSharedPref.getCurrentUser();
      if (_currentUnit == null) return;

      _isLoading = true;
      notifyListeners();

      final data = await ApiService.getMonthBill(_currentUnit!);
      if (data != null) {
        _currentBill = MonthBillModel.fromMap(data);
        await MonthBillSharedPref.saveMonthBill(_currentBill!);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      AppLogger.e('Error getting current month bill: $e');
    }
  }

  Future<void> reloadMonthBill() async {
    if (_currentUnit == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.getMonthBill(_currentUnit!);
      if (data != null) {
        _currentBill = MonthBillModel.fromMap(data);
        try {
          MonthBillSharedPref.saveMonthBill(_currentBill!);
        } catch (e) {
          AppLogger.d('Error saving month bill: $e');
        }
      }
    } catch (e) {
      AppLogger.d('Error reloading bill: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
