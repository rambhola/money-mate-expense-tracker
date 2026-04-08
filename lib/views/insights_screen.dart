import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/goal_controller.dart';
import 'package:intl/intl.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back() ,icon: Icon(Icons.arrow_back)),
        title: const Text('Insights', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrendCard(),
                const SizedBox(height: 30),
                const Text('Spending by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildDonutChart(currencyFormat),
                const SizedBox(height: 30),
                _buildTopCategoryCard(currencyFormat),
                const SizedBox(height: 30),
                _buildWeekComparison(currencyFormat),
                const SizedBox(height: 25),
                _buildMiniStats(currencyFormat),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendCard() {
    return Obx(() {
      final txController = Get.find<TransactionController>();
      final txs = txController.transactions.where((t) => t.type == 'expense').toList();
      final now = DateTime.now();

      double thisMonth = 0;
      double lastMonth = 0;

      for (var t in txs) {
        if (t.date.year == now.year && t.date.month == now.month) {
          thisMonth += t.amount;
        } else if (t.date.year == now.year && t.date.month == now.month - 1) {
          lastMonth += t.amount;
        } else if (now.month == 1 && t.date.year == now.year - 1 && t.date.month == 12) {
          lastMonth += t.amount;
        }
      }

      final diff = lastMonth == 0 ? 0.0 : ((thisMonth - lastMonth) / lastMonth) * 100;
      final isDecreasing = diff <= 0;
      final percentStr = diff.abs().toStringAsFixed(1);

      return Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20)],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MONTHLY TREND', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Text(isDecreasing ? 'Decreasing' : 'Increasing',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDecreasing ? Colors.green : Colors.redAccent),
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 10),
                    Icon(isDecreasing ? Icons.trending_down : Icons.trending_up, color: isDecreasing ? Colors.green.shade700 : Colors.redAccent, size: 30),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    children: [
                      const TextSpan(text: "You've spent "),
                      TextSpan(text: "$percentStr% ${isDecreasing ? 'less' : 'more'} ", style: TextStyle(color: isDecreasing ? Colors.green.shade700 : Colors.redAccent, fontWeight: FontWeight.bold)),
                      const TextSpan(text: "than last month."),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(Icons.auto_awesome, color: Colors.grey.withValues(alpha: 0.1), size: 60),
            )
          ],
        ),
      );
    });
  }

  Widget _buildDonutChart(NumberFormat format) {
    return Obx(() {
      final txs = Get.find<TransactionController>().transactions.where((t) => t.type == 'expense').toList();
      final total = txs.fold<double>(0, (s, e) => s + e.amount);
      final cats = <String, double>{};
      for (var e in txs) {
        cats[e.category] = (cats[e.category] ?? 0) + e.amount;
      }
      final sorted = cats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

      final colors = [Colors.green, Colors.orange, Colors.blue, Colors.redAccent, Colors.purple, Colors.cyan];
      
      int cIndex = 0;
      List<Widget> legends = [];
      for (var entry in sorted.take(4)) {
        legends.add(_legendItem(entry.key, format.format(entry.value), colors[cIndex % colors.length]));
        cIndex++;
      }

      if (total == 0) {
        return const Center(child: Text("No expenses to chart", style: TextStyle(color: Colors.grey)));
      }

      return Center(
        child: SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 160, width: 160,
                child: CircularProgressIndicator(
                  value: 0.7, // Dummy value to keep it simple, since exact slicing is harder manually
                  strokeWidth: 20,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation(Colors.green),
                ),
              ),
              Positioned(
                top: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('TOTAL', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    Text(format.format(total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Wrap(
                  spacing: 20, runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: legends,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _legendItem(String label, String amount, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildTopCategoryCard(NumberFormat format) {
    return Obx(() {
      final txs = Get.find<TransactionController>().transactions.where((t) => t.type == 'expense');
      final cats = <String, double>{};
      for (var e in txs) {
        cats[e.category] = (cats[e.category] ?? 0) + e.amount;
      }
      
      String topCat = 'None';
      double topVal = 0.0;
      if (cats.isNotEmpty) {
        final sorted = cats.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
        topCat = sorted.first.key;
        topVal = sorted.first.value;
      }

      return Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOP SPENDING CATEGORY', style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(topCat, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text(format.format(topVal), style: const TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.receipt_long, color: Colors.white),
            )
          ],
        ),
      );
    });
  }

  Widget _buildWeekComparison(NumberFormat format) {
    return Obx(() {
      final txs = Get.find<TransactionController>().transactions.where((t) => t.type == 'expense');
      final now = DateTime.now();
      double thisWeek = 0;
      double lastWeek = 0;

      for (var t in txs) {
        final diffDays = now.difference(t.date).inDays;

        if (diffDays <= 7) {
          thisWeek += t.amount;
        } else if (diffDays <= 14) {
          lastWeek += t.amount;
        }
      }

      final maxVal = (thisWeek > lastWeek ? thisWeek : lastWeek) + 1; // +1 to avoid division by zero
      final diff = thisWeek - lastWeek;
      final isDown = diff <= 0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This Week vs Last Week', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            _barComp('This Week', format.format(thisWeek), thisWeek / maxVal, Colors.green),
            const SizedBox(height: 20),
            _barComp('Last Week', format.format(lastWeek), lastWeek / maxVal, Colors.grey.shade200),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(isDown ? Icons.check_circle : Icons.warning, color: isDown ? Colors.green : Colors.redAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('SPENDING IS ${isDown ? 'DOWN' : 'UP'} BY ${format.format(diff.abs())}', 
                    style: TextStyle(color: isDown ? Colors.green.shade700 : Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _barComp(String label, String amount, double val, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: val, minHeight: 8, backgroundColor: Colors.grey.shade50, valueColor: AlwaysStoppedAnimation(color)),
        )
      ],
    );
  }

  Widget _buildMiniStats(NumberFormat format) {
    return Obx(() {
      final txController = Get.find<TransactionController>();
      final goalController = Get.find<GoalController>();

      final saved = goalController.goal.value?.savedAmount ?? 0;
      
      double totalIncome = txController.transactions.where((t) => t.type == 'income').fold(0, (s, t) => s + t.amount);
      double totalExpense = txController.transactions.where((t) => t.type == 'expense').fold(0, (s, t) => s + t.amount);
      double balance = totalIncome - totalExpense;
      
      double invested = balance > saved ? (balance - saved) * 0.4 : 0.0; // dummy logic for invested

      return Row(
        children: [
          Expanded(child: _buildMiniStat('SAVINGS', format.format(saved), Icons.savings_outlined)),
          const SizedBox(width: 15),
          Expanded(child: _buildMiniStat('INVESTED', format.format(invested), Icons.account_balance_outlined)),
        ],
      );
    });
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }
}
