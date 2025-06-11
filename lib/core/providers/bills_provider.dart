import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../features/bills/data/month_bill_model.dart';
import '../../features/bills/data/transaction_history_model.dart';
import '../global/current_user_model.dart';
import '../logger/app_logger.dart';
import '../services/api_service.dart';
import '../usecases/month_bill_shared_pref.dart';
import '../usecases/transaction_history_shared_pref.dart';
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

  /// Initialize the bills provider and fetch all necessary data
  Future<void> initialize() async {
    try {
      await _loadUserData();
      if (_currentUnit == null) return;

      await Future.wait([_fetchCurrentMonthBill(), _fetchTransactionHistory()]);
    } catch (e) {
      AppLogger.e('Error initializing BillsProvider: $e');
    }
  }

  /// Load user data from shared preferences
  Future<void> _loadUserData() async {
    try {
      _currentUnit = await UnitSharedPref.getUnit();
      _currentUser = await UserSharedPref.getCurrentUser();
    } catch (e) {
      AppLogger.e('Error loading user data: $e');
      rethrow;
    }
  }

  /// Fetch current month bill from API
  Future<void> _fetchCurrentMonthBill() async {
    if (_currentUnit == null) return;

    try {
      _setLoading(true);
      final data = await ApiService.getMonthBill(_currentUnit!);
      if (data != null) {
        _currentBill = MonthBillModel.fromMap(data);
        await _saveCurrentMonthBill();
      }
    } catch (e) {
      AppLogger.e('Error fetching current month bill: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Save current month bill to shared preferences
  Future<void> _saveCurrentMonthBill() async {
    try {
      if (_currentBill != null) {
        await MonthBillSharedPref.saveMonthBill(_currentBill!);
      }
    } catch (e) {
      AppLogger.e('Error saving current month bill: $e');
    }
  }

  /// Fetch transaction history from API
  Future<void> _fetchTransactionHistory() async {
    if (_currentUnit == null) return;

    try {
      _setLoading(true);
      _transactionHistory = await ApiService.getTransactionHistory(
        _currentUnit!,
      );
      await _saveTransactionHistory();
    } catch (e) {
      AppLogger.e('Error fetching transaction history: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Save transaction history to shared preferences
  Future<void> _saveTransactionHistory() async {
    try {
      if (_transactionHistory != null) {
        await TransactionHistorySharedPref.saveTransactionHistory(
          _transactionHistory!,
        );
      }
    } catch (e) {
      AppLogger.e('Error saving transaction history: $e');
    }
  }

  /// Load transaction history from shared preferences
  Future<void> loadTransactionHistory() async {
    try {
      final history =
          await TransactionHistorySharedPref.getTransactionHistory();
      if (history != null) {
        _transactionHistory = history;
        notifyListeners();
      }
    } catch (e) {
      AppLogger.e('Error loading transaction history: $e');
    }
  }

  /// Set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Reload all data
  Future<void> reload() async {
    await initialize();
  }

  void testLoading() {
    _isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      _isLoading = false;
      notifyListeners();
    });
  }
}
