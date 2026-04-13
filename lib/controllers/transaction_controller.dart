import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TransactionController extends GetxController {
  late Box<Transaction> _transactionBox;
  final transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _transactionBox = Hive.box<Transaction>('transactions');
    _loadTransactions();
  }

  void _loadTransactions() {
    final sortedTx = _transactionBox.values.toList();
    sortedTx.sort((a, b) => b.date.compareTo(a.date));
    transactions.assignAll(sortedTx);
  }

  void addTransaction(Transaction transaction) {
    _transactionBox.put(transaction.id, transaction);
    _loadTransactions();
  }

  bool updateTransaction({
    required String id,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required String description,
  }) {
    final existingTx = _transactionBox.get(id);
    if (existingTx == null) {
      Get.snackbar('Error', 'Transaction not found', snackPosition: SnackPosition.TOP, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    existingTx.title = title;
    existingTx.amount = amount;
    existingTx.category = category;
    existingTx.date = date;
    existingTx.description = description;
    existingTx.save();

    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      transactions[index] = existingTx;
    }

    Get.snackbar(
      'Success',
      'Transaction updated successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
    );
    return true;
  }

  void deleteTransaction(String id) {
    _transactionBox.delete(id);
    _loadTransactions();
  }

  double get totalIncome => transactions
      .where((t) => t.type == 'income')
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == 'expense')
      .fold(0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  Map<String, List<Transaction>> getGroupedTransactions({
    required String filter,
    required String category,
    required String searchQuery,
  }) {
    List<Transaction> txs = transactions.toList(); // Safe copy

    if (filter != 'All') {
      txs = txs.where((t) => t.type.toLowerCase() == filter.toLowerCase()).toList();
    }
    if (category != 'All') {
      txs = txs.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (searchQuery.isNotEmpty) {
      txs = txs.where((t) => t.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    final Map<String, List<Transaction>> grouped = {};
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    for (var t in txs) {
      final tDateStr = DateFormat('yyyy-MM-dd').format(t.date);
      String groupKey;
      if (tDateStr == todayStr) {
        groupKey = 'Today';
      } else if (tDateStr == yesterdayStr) {
        groupKey = 'Yesterday';
      } else {
        groupKey = DateFormat('MMM dd, yyyy').format(t.date);
      }

      if (!grouped.containsKey(groupKey)) grouped[groupKey] = [];
      grouped[groupKey]!.add(t);
    }

    return grouped;
  }
}
