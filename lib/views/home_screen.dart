import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/goal_controller.dart';
import '../controllers/profile_controller.dart';
import 'package:intl/intl.dart';
import 'add_transaction_screen.dart';
import 'goals_screen.dart';
import 'insights_screen.dart';
import 'transaction_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txController = Get.find<TransactionController>();
    final goalController = Get.find<GoalController>();
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 2);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 25),
                _buildQuickActions(),
                const SizedBox(height: 25),
                _buildSavingsGoal(goalController),
                const SizedBox(height: 25),
                _buildBalanceCard(txController, currencyFormat),
                const SizedBox(height: 30),
                _buildSpendingOverview(),
                const SizedBox(height: 30),
                _buildRecentTransactions(txController, currencyFormat),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final profileCtrl = Get.find<ProfileController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Obx(() {
                final imagePath = profileCtrl.imagePath.value;
                return CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imagePath.isNotEmpty 
                    ? FileImage(File(imagePath)) as ImageProvider
                    : const NetworkImage('https://i.pravatar.cc/150?u=a'),
              );
            }),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello,', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  Obx(() => Text(profileCtrl.name.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ],
        ),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none_outlined, color: Colors.blueGrey.shade700),
          onPressed: () {
            Get.snackbar('Notifications', 'No new notifications currently.',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.white, colorText: Colors.black);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionItem(Icons.add_circle, 'Add Income', const Color(0xFFE8F5E9), Colors.green, onTap: () {
          Get.to(() => const AddTransactionScreen(type: 'income'));
        }),
        _quickActionItem(Icons.remove_circle, 'Add Expense', const Color(0xFFFFEBEE), Colors.redAccent, onTap: () {
          Get.to(() => const AddTransactionScreen(type: 'expense'));
        }),
        _quickActionItem(Icons.swap_horizontal_circle, 'Transactions', const Color(0xFFE3F2FD), Colors.blue, onTap: () {
          Get.to(() => const TransactionHistoryScreen());
        }),
      ],
    );
  }

  Widget _quickActionItem(IconData icon, String label, Color bgColor, Color iconColor, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoal(GoalController controller) {
    return GestureDetector(
      onTap: () => Get.to(() => GoalsScreen()),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 03),blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Obx(() {
          final goal = controller.goal.value;
          if (goal == null) return const Center(child: Text('Set a savings goal'));
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(child: Text('Savings Goal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text('₹${goal.savedAmount.toInt()} / ₹${goal.targetAmount.toInt()}', 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Current Goal', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: controller.progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(controller.progress * 100).toInt()}% COMPLETED', 
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                const Text('KEEP IT UP!', 
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ],
        );
      }),
      ),
    );
  }

  Widget _buildBalanceCard(TransactionController controller, NumberFormat format) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CURRENT BALANCE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Obx(() => Text(format.format(controller.totalBalance), 
            style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold))),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(child: _balanceInfoItem('INCOME', controller, format)),
              Container(width: 1, height: 40, color: Colors.white24),
              Expanded(child: _balanceInfoItem('EXPENSE', controller, format)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _balanceInfoItem(String label, TransactionController controller, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(label == 'INCOME' ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white70, size: 12),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          Obx(() {
            final amount = label == 'INCOME' ? controller.totalIncome : controller.totalExpense;
            return Text(format.format(amount), 
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
          }),
        ],
      ),
    );
  }

  Widget _buildSpendingOverview() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Spending Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Get.to(() => InsightsScreen()),
              child: const Text('View Details', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 180,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 02), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WEEKLY FLOW', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Obx(() {
                        final txController = Get.find<TransactionController>();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _getWeeklyBars(txController.transactions),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Obx(() {
                final txController = Get.find<TransactionController>();
                final expenses = txController.transactions.where((t) => t.type == 'expense').toList();
                
                final cats = <String, double>{};
                for(var e in expenses) {
                   cats[e.category] = (cats[e.category] ?? 0) + e.amount;
                }
                
                final sortedCats = cats.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
                final top1 = sortedCats.isNotEmpty ? sortedCats[0] : const MapEntry('None', 0.0);
                final top2 = sortedCats.length > 1 ? sortedCats[1] : const MapEntry('None', 0.0);
                
                final format = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

                return Column(
                  children: [
                    _miniCategoryCard(top1.key, format.format(top1.value), const Color(0xFFFBE9E7), Colors.deepOrange),
                    const SizedBox(height: 15),
                    _miniCategoryCard(top2.key, format.format(top2.value), const Color(0xFFE3F2FD), Colors.blue),
                  ],
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _getWeeklyBars(List<dynamic> txs) {
    if (txs.isEmpty) {
       return [
         _bar(0.1, 'M', false), _bar(0.1, 'T', false), _bar(0.1, 'W', false),
         _bar(0.1, 'T', false), _bar(0.1, 'F', false),
       ];
    }
    
    // Group last 5 days
    final now = DateTime.now();
    final List<double> dailyTotals = List.filled(5, 0.0);
    final List<String> labels = [];
    
    for (int i = 4; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      labels.add(DateFormat('E').format(date).substring(0, 1));
      
      final total = txs.where((t) => t.type == 'expense' &&
          t.date.year == date.year && t.date.month == date.month && t.date.day == date.day)
          .fold<double>(0, (sum, t) => sum + t.amount);
      dailyTotals[4 - i] = total;
    }
    
    double max = dailyTotals.reduce((a, b) => a > b ? a : b);
    if (max == 0) max = 1;
    
    return List.generate(5, (index) {
       return _bar(dailyTotals[index] / max, labels[index], index == 4);
    });
  }

  Widget _bar(double height, String label, bool active) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 25,
          height: 80 * height,
          decoration: BoxDecoration(
            color: active ? Colors.green : Colors.blue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10, color: active ? Colors.green : Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _miniCategoryCard(String label, String amount, Color bgColor, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(label == 'Food' ? Icons.restaurant : Icons.directions_car, color: color, size: 20),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          Text(amount, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(TransactionController controller, NumberFormat format) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Get.to(() => const TransactionHistoryScreen()), 
              child: const Text('View All', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
            ),
          ],
        ),
        Obx(() {
          final txs = controller.transactions.take(3).toList();
          return Column(
            children: txs.map((tx) => _transactionItem(tx, format)).toList(),
          );
        }),
      ],
    );
  }

  Widget _transactionItem(dynamic tx, NumberFormat format) {
    final isExpense = tx.type == 'expense';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
            child: Icon(_getIcon(tx.category), color: Colors.blueGrey, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${tx.category} • ${DateFormat('hh:mm a').format(tx.date)}', 
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${isExpense ? '-' : '+'} ${format.format(tx.amount)}', 
                style: TextStyle(color: isExpense ? Colors.redAccent : Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
              Text(isExpense ? 'DEBIT' : 'CREDIT', 
                style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Icons.coffee;
      case 'salary': return Icons.wallet;
      default: return Icons.receipt_long;
    }
  }
}
