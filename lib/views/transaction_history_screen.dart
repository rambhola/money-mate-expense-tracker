import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

import 'add_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String selectedFilter = 'All';
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final txController = Get.find<TransactionController>();
    final currencyFormat = NumberFormat.currency(
      symbol: r'$',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              Get.bottomSheet(
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Filter by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            [
                                  'All',
                                  'Food',
                                  'Salary',
                                  'Rent',
                                  'Shopping',
                                  'Transport',
                                  'Bills',
                                  'Others',
                                ]
                                .map(
                                  (cat) => ChoiceChip(
                                    label: Text(cat),
                                    selected: selectedCategory == cat,
                                    selectedColor: Colors.green.shade200,
                                    onSelected: (val) {
                                      setState(() => selectedCategory = cat);
                                      Get.back();
                                    },
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
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
              decoration: InputDecoration(
                hintText: 'Search transactions',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          _buildFilters(),
          Expanded(
            child: Obx(() {
              final filtered = _getFilteredTransactions(
                txController.transactions,
              );
              if (filtered.isEmpty) {
                return const Center(child: Text('No transactions found.'));
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _groupTitle('Today'),
                  ...filtered
                      .take(2)
                      .map((t) => _transactionCard(t, currencyFormat)),
                  const SizedBox(height: 10),
                  _groupTitle('Yesterday'),
                  ...filtered
                      .skip(2)
                      .map((t) => _transactionCard(t, currencyFormat)),
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Get.to(() => const AddTransactionScreen(type: 'expense')),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          'All',
          'Income',
          'Expense',
        ].map((f) => _filterChip(f)).toList(),
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
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _groupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            title == 'Today' ? 'OCT 24' : 'OCT 23',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _transactionCard(Transaction tx, NumberFormat format) {
    final isExpense = tx.type == 'expense';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(tx.category),
              color: Colors.green.shade800,
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${DateFormat('hh:mm a').format(tx.date)} • ${tx.description.isEmpty ? 'Monthly payment' : tx.description}',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '${isExpense ? '-' : '+'}${format.format(tx.amount)}',
            style: TextStyle(
              color: isExpense ? Colors.redAccent : Colors.green.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> _getFilteredTransactions(List<Transaction> txs) {
    var filtered = txs;
    if (selectedFilter != 'All') {
      filtered = filtered
          .where((t) => t.type.toLowerCase() == selectedFilter.toLowerCase())
          .toList();
    }
    if (selectedCategory != 'All') {
      filtered = filtered
          .where(
            (t) => t.category.toLowerCase() == selectedCategory.toLowerCase(),
          )
          .toList();
    }
    return filtered;
  }

  IconData _getIcon(String cat) {
    if (cat.toLowerCase().contains('food')) return Icons.coffee;
    if (cat.toLowerCase().contains('salary')) return Icons.savings;
    if (cat.toLowerCase().contains('rent')) return Icons.home;
    if (cat.toLowerCase().contains('netflix')) return Icons.movie;
    return Icons.shopping_cart;
  }
}
