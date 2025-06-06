import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/logger/app_logger.dart';

class TransactionHistorySharedPref {
  static const String _key = 'transaction_history';

  // Save list of transactions
  static Future<void> saveTransactions(
    List<Map<String, dynamic>> transactions,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList =
          transactions.map((t) => json.encode(t)).toList();
      await prefs.setStringList(_key, jsonList);
    } catch (e) {
      AppLogger.e('Error saving transactions: $e');
      rethrow;
    }
  }

  // Get list of transactions
  static Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_key);

      if (jsonList == null) return [];

      return jsonList
          .map((jsonStr) => Map<String, dynamic>.from(json.decode(jsonStr)))
          .toList();
    } catch (e) {
      AppLogger.e('Error getting transactions: $e');
      return [];
    }
  }

  // Clear all transactions
  static Future<void> clearTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      AppLogger.e('Error clearing transactions: $e');
      rethrow;
    }
  }

  // Add a single transaction
  static Future<void> addTransaction(Map<String, dynamic> transaction) async {
    try {
      final transactions = await getTransactions();
      transactions.add(transaction);
      await saveTransactions(transactions);
    } catch (e) {
      AppLogger.e('Error adding transaction: $e');
      rethrow;
    }
  }

  // Update a transaction
  static Future<void> updateTransaction(
    Map<String, dynamic> updatedTransaction,
  ) async {
    try {
      final transactions = await getTransactions();
      final index = transactions.indexWhere(
        (t) => t['id'] == updatedTransaction['id'],
      );

      if (index != -1) {
        transactions[index] = updatedTransaction;
        await saveTransactions(transactions);
      }
    } catch (e) {
      AppLogger.e('Error updating transaction: $e');
      rethrow;
    }
  }

  // Delete a transaction
  static Future<void> deleteTransaction(String id) async {
    try {
      final transactions = await getTransactions();
      transactions.removeWhere((t) => t['id'] == id);
      await saveTransactions(transactions);
    } catch (e) {
      AppLogger.e('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Get transactions by unit
  static Future<List<Map<String, dynamic>>> getTransactionsByUnit(
    String unit,
  ) async {
    try {
      final transactions = await getTransactions();
      return transactions.where((t) => t['unit'] == unit).toList();
    } catch (e) {
      AppLogger.e('Error getting transactions by unit: $e');
      return [];
    }
  }

  // Get latest transaction for a unit
  static Future<Map<String, dynamic>?> getLatestTransaction(String unit) async {
    try {
      final transactions = await getTransactionsByUnit(unit);
      if (transactions.isEmpty) return null;

      // Sort by id in descending order and get the first one
      transactions.sort((a, b) => b['id'].compareTo(a['id']));
      return transactions.first;
    } catch (e) {
      AppLogger.e('Error getting latest transaction: $e');
      return null;
    }
  }

  // Get transactions by date range
  static Future<List<Map<String, dynamic>>> getTransactionsByDateRange(
    String unit,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final transactions = await getTransactionsByUnit(unit);
      return transactions.where((t) {
        final date = DateTime.parse(t['date']);
        return date.isAfter(startDate) && date.isBefore(endDate);
      }).toList();
    } catch (e) {
      AppLogger.e('Error getting transactions by date range: $e');
      return [];
    }
  }

  // Get unpaid transactions
  static Future<List<Map<String, dynamic>>> getUnpaidTransactions(
    String unit,
  ) async {
    try {
      final transactions = await getTransactionsByUnit(unit);
      return transactions.where((t) => t['paid'] == 'N').toList();
    } catch (e) {
      AppLogger.e('Error getting unpaid transactions: $e');
      return [];
    }
  }

  // Get paid transactions
  static Future<List<Map<String, dynamic>>> getPaidTransactions(
    String unit,
  ) async {
    try {
      final transactions = await getTransactionsByUnit(unit);
      return transactions.where((t) => t['paid'] == 'Y').toList();
    } catch (e) {
      AppLogger.e('Error getting paid transactions: $e');
      return [];
    }
  }

  // Get total balance
  static Future<double> getTotalBalance(String unit) async {
    try {
      final transactions = await getTransactionsByUnit(unit);
      double total = 0.0;
      for (var t in transactions) {
        total += double.tryParse(t['balance']?.toString() ?? '0') ?? 0;
      }
      return total;
    } catch (e) {
      AppLogger.e('Error calculating total balance: $e');
      return 0.0;
    }
  }

  // Get total due
  static Future<double> getTotalDue(String unit) async {
    try {
      final transactions = await getUnpaidTransactions(unit);
      double total = 0.0;
      for (var t in transactions) {
        total += double.tryParse(t['totalDue']?.toString() ?? '0') ?? 0;
      }
      return total;
    } catch (e) {
      AppLogger.e('Error calculating total due: $e');
      return 0.0;
    }
  }
}
