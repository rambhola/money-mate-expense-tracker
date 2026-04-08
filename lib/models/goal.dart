import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  double targetAmount;

  @HiveField(1)
  double savedAmount;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  Goal({
    required this.targetAmount,
    required this.savedAmount,
    required this.startDate,
    required this.endDate,
  });
}
