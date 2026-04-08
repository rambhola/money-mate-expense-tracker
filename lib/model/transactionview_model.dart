import 'package:flutter/material.dart';
import 'package:money_mate/model/finance_entry.dart';
import 'package:money_mate/model/transaction_model.dart';

class TransactionViewModel extends ChangeNotifier {
  String selectedType = "Income";
  double amount = 0;
  String category = "";
  String note = "";
  DateTime selectedDate = DateTime.now();

  void setType(String type) {
    selectedType = type;
    notifyListeners();
  }

  void setAmount(double value) {
    amount = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void setNote(String value) {
    note = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  FinanceEntryModel createTransaction() {
    return FinanceEntryModel(
      type: selectedType,
      amount: amount,
      category: category,
      note: note,
      date: selectedDate,
    );
  }
}
