import 'package:flutter/foundation.dart';

import '../../features/bills/data/month_bill_model.dart';
import '../../features/bills/data/transaction_history_model.dart';
import '../global/current_user_model.dart';
import '../logger/app_logger.dart';
import '../services/api_service.dart';
import '../usecases/month_bill_shared_pref.dart';
import '../usecases/unit_shared_pref.dart';
import '../usecases/user_shared_pref.dart';

class BillsProvider with ChangeNotifier {
  String? _currentUnit;
  CurrentUserModel? _currentUser;
  MonthBillModel? _currentBill;
  TransactionHistoryModel? _transactionHistory;
  bool _isLoading = false;

  String? get currentUnit => _currentUnit;
  CurrentUserModel? get currentUser => _currentUser;
  MonthBillModel? get currentBill => _currentBill;
  TransactionHistoryModel? get transactionHistory => _transactionHistory;
  bool get isLoading => _isLoading;

  BillsProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _currentUnit = await UnitSharedPref.getUnit();
      _currentUser = await UserSharedPref.getCurrentUser();
      if (_currentUnit == null) return;

      await getCurrentMonthBill();
      await getTransactionHistory();
    } catch (e) {
      AppLogger.e('Error initializing BillsProvider: $e');
    }
  }

  Future<void> getCurrentMonthBill() async {
    if (_currentUnit == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiService.getMonthBill(_currentUnit!);
      if (data != null) {
        _currentBill = MonthBillModel.fromMap(data);
        await MonthBillSharedPref.saveMonthBill(_currentBill!);
      }
    } catch (e) {
      AppLogger.e('Error getting current month bill: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reloadMonthBill() async {
    if (_currentUnit == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiService.getMonthBill(_currentUnit!);
      if (data != null) {
        _currentBill = MonthBillModel.fromMap(data);
        try {
          await MonthBillSharedPref.saveMonthBill(_currentBill!);
        } catch (e) {
          AppLogger.e('Error saving month bill: $e');
        }
      }
    } catch (e) {
      AppLogger.e('Error reloading bill: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTransactionHistory() async {
    if (_currentUnit == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiService.getTransactionHistory(_currentUnit!);

      _transactionHistory = data;

      // await TransactionHistorySharedPref.saveTransactions(
      //   _transactionHistory!.transactionHistory!.map((e) => e.toMap()).toList(),
      // );
    } catch (e) {
      AppLogger.e('Error getting transaction history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
