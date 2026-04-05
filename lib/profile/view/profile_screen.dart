import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_mate/screens/views/home/home_screen.dart';
import 'package:money_mate/profile/view_model/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),

                SizedBox(height: height * 0.01),

                /// Profile Header
                _buildProfileHeader(width, height),

                SizedBox(height: height * 0.04),

                /// Balance Card
                _buildBalanceCard(width),

                SizedBox(height: height * 0.04),

                /// Options
                _buildOption(Icons.person, "Edit Profile"),
                _buildOption(Icons.notifications, "Notifications"),
                _buildOption(Icons.lock, "Security"),
                _buildOption(Icons.help, "Help & Support"),

                SizedBox(height: height * 0.02),

                /// Logout
                _buildOption(Icons.logout, "Logout", isLogout: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Profile Header
  Widget _buildProfileHeader(double width, double height) {
    return Center(
      child: Column(
        children: [
          /// Avatar
          GestureDetector(
            onTap: _showEditProfileDialog,
            child: Obx(
                  () => CircleAvatar(
                radius: width * 0.12,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: profileController.imageFile.value != null
                    ? FileImage(profileController.imageFile.value!)
                    : const AssetImage(
                  "assets/assets/avatar/profile_avtar.png",
                ) as ImageProvider,
              ),
            ),
          ),

          SizedBox(height: height * 0.02),

          /// Name
          Obx(
                () => Text(
              profileController.name.value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Email
          Obx(
                () => Text(
              profileController.email.value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          SizedBox(height: height * 0.02),

          /// Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => Get.to(() => HomeScreen()),
            child: const Text(
              "Update Image",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Balance Card
  Widget _buildBalanceCard(double width) {
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B8E3E), Color(0xFF4CAF50)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TOTAL BALANCE",
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 8),
          Text(
            "₹45,280.00",
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Option Tile
  Widget _buildOption(IconData icon, String title, {bool isLogout = false}) {
    return InkWell(
      onTap: () {
        if (title == "Edit Profile") {
          _showEditProfileDialog();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.red : Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  /// Edit Profile Dialog
  void _showEditProfileDialog() {
    final nameController =
    TextEditingController(text: profileController.name.value);
    final emailController =
    TextEditingController(text: profileController.email.value);

    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Avatar Picker
              GestureDetector(
                onTap: () async {
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    profileController.setImage(File(pickedFile.path));
                  }
                },
                child: Obx(
                      () => CircleAvatar(
                    radius: 40,
                    backgroundImage: profileController.imageFile.value != null
                        ? FileImage(profileController.imageFile.value!)
                        : const AssetImage(
                      "assets/assets/avatar/profile_avtar.png",
                    ) as ImageProvider,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Name Field
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Enter Name"),
              ),

              const SizedBox(height: 10),

              /// Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Enter Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                profileController.setName(nameController.text.trim());
                profileController.setEmail(emailController.text.trim());
                Get.back();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}