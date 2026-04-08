import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import 'package:uuid/uuid.dart';


class AddTransactionScreen extends StatefulWidget {
  final String type; // 'income' or 'expense'
  const AddTransactionScreen({super.key, required this.type});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final txController = Get.find<TransactionController>();
  
  String _amount = '0';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Others'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Investment', 'Gift', 'Others'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.type == 'income' ? _incomeCategories.first : _expenseCategories.first;
  }

  void _onNumpadTap(String value) {
    setState(() {
      if (value == 'C') {
        _amount = '0';
      } else if (value == 'DEL') {
        _amount = _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : '0';
      } else if (value == '.') {
        if (!_amount.contains('.')) _amount += value;
      } else {
        if (_amount == '0' && value != '.') {
          _amount = value;
        } else {
          // Limit to 2 decimal places
          if (_amount.contains('.')) {
            final parts = _amount.split('.');
            if (parts.length > 1 && parts[1].length >= 2) return;
          }
          if (_amount.length < 10) _amount += value;
        }
      }
    });
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.type == 'income' ? Colors.green : Colors.redAccent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    final double amountValue = double.tryParse(_amount) ?? 0.0;
    if (amountValue <= 0) {
      Get.snackbar('Invalid Amount', 'Please enter a valid amount greater than 0.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar('Missing Title', 'Please enter a transaction title.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final newTx = Transaction(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      amount: amountValue,
      type: widget.type,
      category: _selectedCategory,
      date: _selectedDate,
      description: _descController.text.trim(),
    );

    txController.addTransaction(newTx);
    
    Get.back();
    Get.snackbar(
      'Success',
      'Transaction added successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.type == 'income';
    final primaryColor = isIncome ? Colors.green.shade700 : Colors.redAccent;
    final categories = isIncome ? _incomeCategories : _expenseCategories;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isIncome ? 'Add Income' : 'Add Expense', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Display
                  Center(
                    child: Column(
                      children: [
                        Text('Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(
                          '₹$_amount',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Transaction Details Form
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                  const SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.grey.shade600),
                          const SizedBox(width: 15),
                          Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: 'Short Description (Optional)',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.notes),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Numpad & Save Area
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 05), blurRadius: 20, offset: const Offset(0, -5))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNumpad(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveTransaction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      child: const Text('Save Document', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', 'DEL'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) => _numpadButton(key)).toList(),
        );
      }).toList(),
    );
  }

  Widget _numpadButton(String label) {
    return GestureDetector(
      onTap: () => _onNumpadTap(label),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 60,
        alignment: Alignment.center,
        child: label == 'DEL' 
          ? const Icon(Icons.backspace_outlined, size: 24, color: Colors.blueGrey)
          : Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87)),
      ),
    );
  }
}
