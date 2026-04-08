import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/transaction.dart';

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
    transactions.assignAll(_transactionBox.values.toList());
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  void addTransaction(Transaction transaction) {
    _transactionBox.put(transaction.id, transaction);
    _loadTransactions();
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
}
