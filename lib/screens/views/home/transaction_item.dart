import 'package:flutter/material.dart';
import '../../../model/transaction_model.dart';


class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.015,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(width * 0.05),
      ),
      child: Row(
        children: [
          /// ICON
          Container(
            padding: EdgeInsets.all(width * 0.03),
            decoration: BoxDecoration(
              color: transaction.isCredit
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction.icon,
              color: transaction.isCredit ? Colors.green : Colors.black54,
              size: isLandscape ? width * 0.03 : width * 0.05,
            ),
          ),

          SizedBox(width: width * 0.04),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize:
                    isLandscape ? width * 0.02 : width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    fontSize:
                    isLandscape ? width * 0.018 : width * 0.032,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// AMOUNT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: TextStyle(
                  fontSize:
                  isLandscape ? width * 0.02 : width * 0.035,
                  fontWeight: FontWeight.bold,
                  color:
                  transaction.isCredit ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: height * 0.003),
              Text(
                transaction.isCredit ? "CREDIT" : "DEBIT",
                style: TextStyle(
                  fontSize:
                  isLandscape ? width * 0.015 : width * 0.025,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}