import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/goal_controller.dart';
import '../models/goal.dart';
import 'package:intl/intl.dart';

class GoalsScreen extends StatelessWidget {
  GoalsScreen({super.key});

  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _savedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final goalController = Get.find<GoalController>();
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
        title: const Text('Goal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildMainGoalCard(goalController, currencyFormat),
              const SizedBox(height: 25),
              _buildDetailInfo(Icons.calendar_today_outlined, 'Time Remaining', '12 days left in this cycle', Colors.green),
              const SizedBox(height: 25),
              _buildDetailInfo(Icons.auto_awesome_outlined, 'Smart Tip', 'Save ₹250 daily to hit your goal.', Colors.blue),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    _targetController.text = goalController.goal.value?.targetAmount.toStringAsFixed(0) ?? '';
                    _savedController.text = '';
                    
                    Get.defaultDialog(
                      title: 'Update Goal',
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _targetController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Target Amount (₹)'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _savedController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Add Saved Amount (₹)'),
                          ),
                        ],
                      ),
                      textConfirm: 'Save',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                         final double target = double.tryParse(_targetController.text) ?? 5000;
                         final double newlySaved = double.tryParse(_savedController.text) ?? 0;
                         if (goalController.goal.value != null) {
                           goalController.goal.value!.targetAmount = target;
                           goalController.goal.value!.save();
                           goalController.updateSavedAmount(newlySaved);
                         } else {
                           goalController.setGoal(Goal(
                              targetAmount: target, 
                              savedAmount: newlySaved,
                              startDate: DateTime.now(),
                              endDate: DateTime.now().add(const Duration(days: 30)),
                           ));
                         }
                         Get.back();
                      }
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Update Goal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainGoalCard(GoalController controller, NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
          )
        ],
      ),
      child: Obx(() {
        final goalData = controller.goal.value;
        final saved = goalData?.savedAmount ?? 0;
        final target = goalData?.targetAmount ?? 5000;

        final double progress =
        target > 0 ? (saved / target).clamp(0.0, 1.0) : 0.0;
        final remaining = target - saved;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT STATUS',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Monthly Savings Goal',
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.savings, color: Colors.green),
                )
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statGroup(
                    'SAVED SO FAR', format.format(saved), CrossAxisAlignment.start),
                _statGroup(
                    'TARGET GOAL', format.format(target), CrossAxisAlignment.end),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(progress * 100).toInt()}% Achieved',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  '${format.format(remaining > 0 ? remaining : 0)} remaining',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade100,
                valueColor: const AlwaysStoppedAnimation(Colors.green),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.blue),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('On Track',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(
                          "You're saving 15% more than last month!",
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _statGroup(String label, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDetailInfo(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }
}
