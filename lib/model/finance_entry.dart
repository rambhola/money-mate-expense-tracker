class FinanceEntryModel {
  String type;
  double amount;
  String category;
  String note;
  DateTime date;

  FinanceEntryModel({
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });
}