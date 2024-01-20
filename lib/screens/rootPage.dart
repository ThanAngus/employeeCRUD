import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_inno_test/bloc/crud_operation_bloc.dart';
import 'package:realtime_inno_test/bloc/employeeBloc.dart';
import 'package:realtime_inno_test/model/employeeModel.dart';
import 'package:realtime_inno_test/screens/addEmployeePage.dart';
import 'package:realtime_inno_test/utils/widget/employeeListCard.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool employeeEmpty = true;
  List<EmployeeModel> employees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Employee List",
        ),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeLoadSuccess) {
            setState(() => employees = state.employees);
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const CircularProgressIndicator();
          } else if (state is EmployeeLoadSuccess) {
            return buildEmployeeList();
          } else if (state is EmployeeOperationFailure) {
            return Text(
              "Failed to load employees",
              style: Theme.of(context).textTheme.bodyMedium,
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmployeePage(),
            ),
          );
        },
        tooltip: 'Add Employee',
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildEmployeeList() {
    if (employees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              width: MediaQuery.of(context).size.width/1.5,
              image: const AssetImage(
                "assets/images/emptyState.png",
              ),
              fit: BoxFit.fitWidth,
            ),
            Text(
              "No employee records found",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      List<EmployeeModel> currentEmployeeList =
          employees.where((element) => element.endDate == null).toList();
      List<EmployeeModel> previousEmployeeList =
          employees.where((element) => element.endDate != null).toList();
      return SingleChildScrollView(
        child: Column(
          children: [
            if (currentEmployeeList.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Current employees",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  ListView.separated(
                    itemBuilder: (context, index) {
                      EmployeeModel employee = currentEmployeeList[index];
                      return EmployeeListCard(
                        employee: employee,
                        onDeleteEmployee: onDeleteEmployee,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 2,
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentEmployeeList.length,
                  ),
                ],
              ),
            if (previousEmployeeList.isNotEmpty)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Previous employees",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  ListView.separated(
                    itemBuilder: (context, index) {
                      EmployeeModel employee = previousEmployeeList[index];
                      return EmployeeListCard(
                        employee: employee,
                        onDeleteEmployee: onDeleteEmployee,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 2,
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.black12,
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: previousEmployeeList.length,
                  ),
                ],
              ),
            if (employees.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Swipe left to delete",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    }
  }

  void onDeleteEmployee(EmployeeModel? employeeModel) {
    final deletedEmployee = employeeModel;
    final deletedEmployeeIndex = employees.indexOf(employeeModel!);

    setState(() {
      employees.removeAt(deletedEmployeeIndex);
    });

    context.read<EmployeeBloc>().add(DeleteEmployee(employeeModel.employeeID));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        content: Text(
          "Employee data has been deleted",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: Colors.white,
          ),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Theme.of(context).primaryColor,
          onPressed: (){
            setState(() {
              employees.insert(deletedEmployeeIndex, deletedEmployee!);
            });
            context.read<EmployeeBloc>().add(AddEmployee(deletedEmployee!));
          },
        ),
      ),
    );
  }
}
