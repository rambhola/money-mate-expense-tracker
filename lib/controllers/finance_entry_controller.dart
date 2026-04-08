import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FinanceEntryController extends GetxController {
  var amount = 0.0.obs;
  var category = "".obs;
  var note = "".obs;
  var selectedDate = DateTime.now().obs;

  void setAmount(double value) {
    amount.value = value;
  }

  void setCategory(String value) {
    category.value = value;
  }

  void setNote(String value) {
    note.value = value;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void createTransaction() {
    debugPrint(amount.value.toString());
    debugPrint(category.value);
    debugPrint(note.value);
    debugPrint(selectedDate.value.toString());
  }
}