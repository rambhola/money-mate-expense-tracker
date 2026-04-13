import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'add_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String selectedFilter = 'All';
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final txController = Get.find<TransactionController>();
    final currencyFormat = NumberFormat.currency(symbol: r'$', decimalDigits: 2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
        actions: [],
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search transactions',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          _buildFilters(),
          Expanded(
            child: Obx(() {
              final groupedData = txController.getGroupedTransactions(
                filter: selectedFilter,
                category: selectedCategory,
                searchQuery: searchQuery,
              );

              if (groupedData.isEmpty) return const Center(child: Text('No transactions found.'));

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: groupedData.length,
                itemBuilder: (context, index) {
                  final groupKey = groupedData.keys.elementAt(index);
                  final transactions = groupedData[groupKey]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _groupTitle(groupKey),
                      ...transactions.map((t) => _transactionCard(t, currencyFormat)),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddTransactionScreen(type: 'expense')),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: ['All', 'Income', 'Expense'].map((f) => _filterChip(f)).toList(),
      ),
    );
  }

  Widget _filterChip(String label) {
    bool active = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.green.shade900 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.grey.shade700, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _groupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _transactionCard(Transaction tx, NumberFormat format) {
    final isExpense = tx.type == 'expense';
    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(22)),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text('Are you sure you want to delete this transaction?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
            ],
          )
      ),
      onDismissed: (direction) => Get.find<TransactionController>().deleteTransaction(tx.id),
      child: GestureDetector(
        onTap: () => Get.to(() => AddTransactionScreen(type: tx.type, transaction: tx)),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                child: Icon(_getIcon(tx.category), color: Colors.green.shade800, size: 22),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${DateFormat('hh:mm a').format(tx.date)} • ${tx.description.isEmpty ? 'Monthly payment' : tx.description}',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ),
              ),
              Text('${isExpense ? '-' : '+'}${format.format(tx.amount)}',
                  style: TextStyle(color: isExpense ? Colors.redAccent : Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }



  IconData _getIcon(String cat) {
    if (cat.toLowerCase().contains('food')) return Icons.coffee;
    if (cat.toLowerCase().contains('salary')) return Icons.savings;
    if (cat.toLowerCase().contains('rent')) return Icons.home;
    if (cat.toLowerCase().contains('netflix')) return Icons.movie;
    return Icons.shopping_cart;
  }
}
