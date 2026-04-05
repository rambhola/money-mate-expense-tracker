import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  // Reactive variables
  var email = "user@gmail.com".obs;
  var name = "User".obs;
  Rxn<File> imageFile = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    loadProfile(); // Load saved data on init
  }

  /// Update the user name and save to SharedPreferences
  void setName(String newName) {
    name.value = newName;
    saveProfile();
  }

  /// Update the user email and save to SharedPreferences
  void setEmail(String newEmail) {
    email.value = newEmail;
    saveProfile();
  }

  /// Update the profile image, copy to app directory and save
  Future<void> setImage(File file) async {
    try {
      // Copy image to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = file.path.split('/').last;
      final savedFile = await file.copy('${appDir.path}/$fileName');

      imageFile.value = savedFile;
      saveProfile();
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  /// Save name and image path to SharedPreferences
  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name.value);
    await prefs.setString('profile_email', email.value);
    if (imageFile.value != null) {
      await prefs.setString('profile_image', imageFile.value!.path);
    }
  }

  /// Load name,email and image path from SharedPreferences
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('profile_name') ?? 'User';
    email.value = prefs.getString("profile_email") ?? "user@gmail.com";

    final imagePath = prefs.getString('profile_image');
    if (imagePath != null && File(imagePath).existsSync()) {
      imageFile.value = File(imagePath);
    }
  }
}
