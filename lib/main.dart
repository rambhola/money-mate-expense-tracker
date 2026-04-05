import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_mate/profile/view_model/ImagePickerController.dart';
import 'package:money_mate/profile/view_model/profile_controller.dart';
import 'navbar/views/bottom_nav.dart';
import 'navbar/views_model/nav_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inject controllers
  Get.put(ImagePickerController());
  Get.put(ProfileController());
  Get.put(NavController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // optional, adjust to your design
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: BottomNavScreen(),
        );
      },
    );
  }
}