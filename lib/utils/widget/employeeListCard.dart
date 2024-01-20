import 'package:flextras/flextras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realtime_inno_test/model/employeeModel.dart';
import 'package:realtime_inno_test/screens/addEmployeePage.dart';

class EmployeeListCard extends StatelessWidget {
  final EmployeeModel employee;
  final Function(EmployeeModel?) onDeleteEmployee;

  const EmployeeListCard({
    required this.employee,
    required this.onDeleteEmployee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEmployeePage(
              employeeModel: employee,
              onDeleteEmployee: onDeleteEmployee,
            ),
          ),
        );
      },
      child: Dismissible(
        key: Key(employee.employeeID),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            CupertinoIcons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onDeleteEmployee(employee);
          }
        },
        direction: DismissDirection.endToStart,
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SeparatedColumn(
                  separatorBuilder: () => const SizedBox(
                    height: 3,
                  ),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      employee.role.name,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    if (employee.endDate != null)
                      Text(
                        "${DateFormat('d MMM, yyyy').format(employee.joinDate)} - ${DateFormat('d MMM, yyyy').format(employee.endDate!)}",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                    if (employee.endDate == null)
                      Text(
                        "From ${DateFormat('d MMM, yyyy').format(employee.joinDate)}",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
