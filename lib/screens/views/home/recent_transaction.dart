import 'package:flutter/material.dart';

import '../../../model/transaction_model.dart';
import '../../../widget/transaction_item.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    /// SAMPLE DATA
    final List<TransactionModel> transactions = [
      TransactionModel(
        title: "Starbucks",
        subtitle: "Food & Drinks • 10:24 AM",
        amount: "- ₹250.00",
        isCredit: false,
        icon: Icons.local_cafe,
      ),
      TransactionModel(
        title: "Salary",
        subtitle: "Income • Aug 01",
        amount: "+ ₹50,000.00",
        isCredit: true,
        icon: Icons.account_balance_wallet,
      ),
      TransactionModel(
        title: "Electricity Bill",
        subtitle: "Utilities • July 28",
        amount: "- ₹2,400.00",
        isCredit: false,
        icon: Icons.receipt_long,
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "View All",
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// LIST
          Column(
            children: transactions
                .map((tx) => TransactionItem(transaction: tx))
                .toList(),
          ),
        ],
      ),
    );
  }
}