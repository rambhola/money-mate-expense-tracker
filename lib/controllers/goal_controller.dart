import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/goal.dart';

class GoalController extends GetxController {
  late Box<Goal> _goalBox;
  final goal = Rxn<Goal>();

  @override
  void onInit() {
    super.onInit();
    _goalBox = Hive.box<Goal>('goals');
    _loadGoal();
  }

  void _loadGoal() {
    if (_goalBox.isNotEmpty) {
      goal.value = _goalBox.getAt(0);
    }
  }

  void setGoal(Goal newGoal) {
    _goalBox.clear();
    _goalBox.add(newGoal);
    goal.value = newGoal;
  }

  void updateSavedAmount(double amount) {
    if (goal.value != null) {
      goal.value!.savedAmount += amount;
      goal.value!.save();
      goal.refresh();
    }
  }

  double get progress {
    if (goal.value == null || goal.value!.targetAmount == 0) return 0.0;
    return (goal.value!.savedAmount / goal.value!.targetAmount).clamp(0.0, 1.0);
  }
}
