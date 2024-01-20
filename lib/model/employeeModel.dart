import 'package:hive/hive.dart';
part 'employeeModel.g.dart';

@HiveType(typeId: 0)
class EmployeeModel extends HiveObject{
  @HiveField(0)
  final String employeeID;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final Roles role;
  @HiveField(3)
  final DateTime joinDate;
  @HiveField(4)
  final DateTime? endDate;

  EmployeeModel({
    required this.employeeID,
    required this.name,
    required this.role,
    required this.joinDate,
    this.endDate,
  });
}

@HiveType(typeId: 1)
enum Roles {
  @HiveField(0)
  productDesigner,
  @HiveField(1)
  flutterDeveloper,
  @HiveField(2)
  qaTester,
  @HiveField(3)
  productOwner;

  String get name {
    switch (this) {
      case Roles.productDesigner:
        return 'Product Designer';
      case Roles.flutterDeveloper:
        return 'Flutter Developer';
      case Roles.qaTester:
        return 'QA Tester';
      case Roles.productOwner:
        return 'Product Owner';
      default:
        return 'Unknown Role';
    }
  }
}
