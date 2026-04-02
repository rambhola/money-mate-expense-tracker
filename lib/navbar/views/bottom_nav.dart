import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../screens/views/add_transaction.dart';
import '../../screens/views/goal_overview_screen.dart';
import '../../screens/views/home_screen.dart';
import '../../screens/views/insights_screen.dart';
import '../views_model/nav_controller.dart';

class BottomNavScreen extends StatelessWidget {
  final int? navIndex;
  const BottomNavScreen({super.key, this.navIndex});

  @override
  Widget build(BuildContext context) {
    final NavController navController = Get.find<NavController>();
    if (navIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navController.selectedIndex(navIndex!.clamp(0, 3));
      });
    }

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navController.selectedIndex.value.clamp(0, 3),
          children: [
            HomeScreen(),
            AddTransaction(),
            InsightsScreen(),
            GoalOverviewScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.white, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: navController.selectedIndex.value.clamp(0, 3),
              // selectedFontSize: isLandscape ? 10 : 12,
              // unselectedFontSize: isLandscape ? 10 : 12,
              selectedItemColor: Colors.green,
              unselectedItemColor: Color(0xFF94A3B8),
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(color: Color(0xFF64748B)),
              elevation: 8.0,
              backgroundColor: Colors.white,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (index) => navController.selectedIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    height: 47,
                    width: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: navController.selectedIndex.value == 0
                          ? const Color(0xff3c8c52)
                          : Colors.transparent,
                    ),
                    child: const Center(child: Icon(Icons.home, size: 18)),
                  ),
                  activeIcon: Container(
                    height: 47,
                    width: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xffECFDF5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.home,
                        size: 18,
                        color: Color(0xff006E1C),
                      ),
                    ),
                  ),
                  label: 'HOME',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 47,
                    width: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: navController.selectedIndex.value == 1
                          ? const Color(0xff3c8c52)
                          : Colors.transparent,
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.creditcard, size: 18),
                    ),
                  ),
                  activeIcon: Container(
                    height: 47,
                    width: 66,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xffECFDF5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.creditcard,
                        size: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  label: 'TRANSACTION',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 47,
                    width: 66,
                    decoration: BoxDecoration(
                      color: navController.selectedIndex.value == 2
                          ? const Color(0xff3c8c52)
                          : Colors.transparent,
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.chart_bar_fill, size: 18),
                    ),
                  ),
                  activeIcon: Container(
                    height: 47,
                    width: 66,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xffECFDF5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.chart_bar_fill,
                        size: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  label: 'INSIGHTS',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 47,
                    width: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: navController.selectedIndex.value == 3
                          ? const Color(0xff3c8c52)
                          : Colors.transparent,
                    ),
                    child: const Center(
                      child: Icon(CupertinoIcons.flag, size: 18),
                    ),
                  ),
                  activeIcon: Container(
                    height: 47,
                    width: 66,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xffECFDF5),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Icon(
                        CupertinoIcons.flag,
                        size: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  label: 'GOALS',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
