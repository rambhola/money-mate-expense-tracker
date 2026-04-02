import 'package:flutter/material.dart';
class GoalOverviewScreen extends StatefulWidget {
  const GoalOverviewScreen({super.key});

  @override
  State<GoalOverviewScreen> createState() => _GoalOverviewScreenState();
}

class _GoalOverviewScreenState extends State<GoalOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GoalOverview Screen"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text( "GoalOverview Screen"),)
        ],
      ),
    );
  }
}
