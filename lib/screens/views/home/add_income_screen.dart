import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/controllers/finance_entry_controller.dart';
import 'package:money_mate/screens/views/home/home_screen.dart';
import '../../../widget/custom_button.dart';

class AddIncomeScreen extends StatelessWidget {
  AddIncomeScreen({super.key});

  final FinanceEntryController controller = Get.put(FinanceEntryController());

  final List<String> categories = [
    "Salary 💰",
    "Bonus 🎁",
    "Freelance 💻",
    "Investment 📈",
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.grid_view),
      ),
      body: Stack(
        children: [_buildHeader(), _buildBottomSheet(context, screenHeight)],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.black.withOpacity(0.1)),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, double screenHeight) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: screenHeight * 0.78,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 20),
              _buildAmountInput(),
              const SizedBox(height: 20),
              _buildCategorySection(),
              const SizedBox(height: 20),
              _buildDatePicker(context),
              const SizedBox(height: 20),
              _buildMemoField(),
              const SizedBox(height: 30),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Add Income",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAmountInput() {
    return Center(
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          hintText: "₹0.00",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          controller.setAmount(double.tryParse(value) ?? 0);
        },
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Category", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 10,
            children: categories.map((cat) {
              return ChoiceChip(
                label: Text(cat),
                selected: controller.category.value == cat,
                selectedColor: Colors.blue,
                onSelected: (_) {
                  controller.setCategory(cat);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Date", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: controller.selectedDate.value,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (picked != null) {
              controller.setDate(picked);
            }
          },
          child: Obx(
            () => Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 10),
                  Text(
                    controller.selectedDate.value.toLocal().toString().split(
                      ' ',
                    )[0],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Memo", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Add a note",
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: controller.setNote,
        ),
      ],
    );
  }

  Widget _buildButton() {
    return CustomButton(
      text: "Add Income",
      onPressed: () {
        controller.createTransaction();

        Get.to(
          () => HomeScreen(), arguments: {
            "amount": controller.amount.value,
            "category": controller.category.value,
            "date": controller.selectedDate.value,
            "note": controller.note.value,
          }
        );
      },
    );
  }
}
