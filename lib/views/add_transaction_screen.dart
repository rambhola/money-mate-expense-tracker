import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  final String type; // 'income' or 'expense'
  final Transaction? transaction;
  const AddTransactionScreen({super.key, required this.type, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final txController = Get.find<TransactionController>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  final List<String> _expenseCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Others'];
  final List<String> _incomeCategories = ['Salary', 'Freelance', 'Investment', 'Gift', 'Others'];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount == tx.amount.toInt() ? tx.amount.toInt().toString() : tx.amount.toString();
      _titleController.text = tx.title;
      _descController.text = tx.description;
      _selectedCategory = tx.category;
      _selectedDate = tx.date;
    } else {
      _selectedCategory = widget.type == 'income' ? _incomeCategories.first : _expenseCategories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
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
    final double amountValue = double.tryParse(_amountController.text) ?? 0.0;
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

    if (widget.transaction != null) {
      final success = txController.updateTransaction(
        id: widget.transaction!.id,
        title: _titleController.text.trim(),
        amount: amountValue,
        category: _selectedCategory,
        date: _selectedDate,
        description: _descController.text.trim(),
      );
      if (success) {
        Get.back();
      }
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final isIncome = widget.type == 'income';
    final primaryColor = isIncome ? Colors.green.shade700 : Colors.redAccent;
    final categories = isIncome ? _incomeCategories : _expenseCategories;

    final amountSection = AmountInputSection(
      amountController: _amountController,
      onSave: _saveTransaction,
      primaryColor: primaryColor,
      isEdit: widget.transaction != null,
      isLandscape: isLandscape,
    );

    final formSection = TransactionFormSection(
      titleController: _titleController,
      descController: _descController,
      selectedCategory: _selectedCategory,
      categories: categories,
      onCategoryChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedCategory = val;
          });
        }
      },
      selectedDate: _selectedDate,
      onPickDate: _pickDate,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.transaction != null ? 'Edit Transaction' : (isIncome ? 'Add Income' : 'Add Expense'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: isLandscape
            ? Row(
          children: [
            SizedBox(
              width: size.width * 0.4,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: amountSection,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: formSection,
              ),
            ),
          ],
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              amountSection,
              const SizedBox(height: 30),
              formSection,
            ],
          ),
        ),
      ),
    );
  }
}

class AmountInputSection extends StatelessWidget {
  final TextEditingController amountController;
  final VoidCallback onSave;
  final Color primaryColor;
  final bool isEdit;
  final bool isLandscape;

  const AmountInputSection({
    super.key,
    required this.amountController,
    required this.onSave,
    required this.primaryColor,
    required this.isEdit,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    final textField = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
          decoration: InputDecoration(
            prefixText: '₹',
            prefixStyle: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            border: InputBorder.none,
            hintText: '0',
          ),
        ),
      ],
    );

    final saveButton = SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(
          isEdit ? 'Save Changes' : 'Save Document',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );

    return Column(
      mainAxisSize: isLandscape ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: isLandscape ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
      children: [
        if (isLandscape) Expanded(child: Center(child: textField)) else textField,
        if (!isLandscape) const SizedBox(height: 20),
        saveButton,
      ],
    );
  }
}

class TransactionFormSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;
  final DateTime selectedDate;
  final VoidCallback onPickDate;

  const TransactionFormSection({
    super.key,
    required this.titleController,
    required this.descController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.selectedDate,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: titleController,
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
          initialValue: selectedCategory,
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: InputDecoration(
            labelText: 'Category',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.category),
          ),
          items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onPickDate,
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
                  DateFormat('MMM dd, yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: descController,
          decoration: InputDecoration(
            labelText: 'Short Description (Optional)',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.notes),
          ),
        ),
      ],
    );
  }
}
