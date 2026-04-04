import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final IconData icon;

  TransactionModel({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.icon,
  });
}