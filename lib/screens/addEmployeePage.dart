import 'dart:math';
import 'dart:convert';
import 'package:flextras/flextras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:realtime_inno_test/bloc/crud_operation_bloc.dart';
import 'package:realtime_inno_test/bloc/employeeBloc.dart';
import 'package:realtime_inno_test/utils/style.dart';
import 'package:realtime_inno_test/utils/widget/customButton.dart';
import 'package:realtime_inno_test/utils/widget/customDatePicker.dart';
import 'package:realtime_inno_test/utils/widget/customTextFormField.dart';
import '../model/employeeModel.dart';

class AddEmployeePage extends StatefulWidget {
  final EmployeeModel? employeeModel;
  final Function(EmployeeModel?)? onDeleteEmployee;

  const AddEmployeePage({
    this.employeeModel,
    this.onDeleteEmployee,
    super.key,
  });

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  late Roles role;
  late String employeeName, employeeID = generateRandomId();
  late DateTime joinDate;
  DateTime? endDate;
  late EmployeeModel employeeModel;

  void updateJoinDate(DateTime? selectedDateTime) {
    setState(() {
      joinDate = selectedDateTime!;
      joinDateController.text = DateFormat('d MMM yyyy').format(selectedDateTime);
    });
  }

  void updateEndDate(DateTime? selectedDateTime) {
    setState(() {
      endDate = selectedDateTime;
      endDateController.text = selectedDateTime == null ? 'No date' : DateFormat('d MMM yyyy').format(selectedDateTime);
    });
  }

  String generateRandomId() {
    final Random random = Random.secure();
    var values = List<int>.generate(5, (i) => random.nextInt(256));
    return base64UrlEncode(values).substring(0, 5);
  }

  @override
  void initState() {
    if (widget.employeeModel != null) {
      employeeID = widget.employeeModel!.employeeID;
      nameController.text = widget.employeeModel!.name;
      roleController.text = widget.employeeModel!.role.name;
      joinDateController.text = DateFormat('d MMM yyyy').format(widget.employeeModel!.joinDate);
      endDateController.text = widget.employeeModel!.endDate != null
          ? DateFormat('d MMM yyyy').format(widget.employeeModel!.endDate!)
          : "No Date";
      joinDate = widget.employeeModel!.joinDate;
      endDate = widget.employeeModel!.endDate;
    }else{
      joinDateController.text = 'Today';
      endDateController.text = 'No Date';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.employeeModel != null
              ? "Edit Employee Details"
              : "Add Employee Details",
        ),
        actions: [
          if (widget.employeeModel != null)
            IconButton(
              onPressed: () {
                widget.onDeleteEmployee!(widget.employeeModel);
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.delete,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: Form(
              key: _key,
              child: SeparatedColumn(
                separatorBuilder: () => const SizedBox(
                  height: 20,
                ),
                children: [
                  CustomTextFormField(
                    hint: 'Employee name',
                    prefixIcon: Icons.person_outline_outlined,
                    textEditingController: nameController,
                    validator: (value) {
                      if (value == "") {
                        return "Employee name is missing";
                      } else {
                        setState(() {
                          employeeName = value!;
                        });
                        return null;
                      }
                    },
                  ),
                  CustomTextFormField(
                    hint: 'Select role',
                    prefixIcon: Icons.work_outline,
                    readOnly: true,
                    textEditingController: roleController,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: false,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Roles e = Roles.values[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () {
                                    setState(() {
                                      role = e;
                                    });
                                    roleController.text = e.name;
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        e.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 5,
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.black12,
                                  ),
                                );
                              },
                              itemCount: Roles.values.length,
                            );
                          });
                        },
                      );
                    },
                    validator: (value) {
                      if (value == "") {
                        return "Employee job role is missing";
                      } else {
                        setState(() {
                          role = Roles.values
                              .where((element) => element.name == value)
                              .first;
                        });
                        return null;
                      }
                    },
                    suffixWidget: Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 28,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          hint: 'Join Date',
                          prefixIcon: Icons.today,
                          readOnly: true,
                          textEditingController: joinDateController,
                          textStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          validator: (value) {
                            if (value == '') {
                              return "Join date is missing";
                            } else {
                              setState(() {
                                joinDate = joinDate;
                              });
                              return null;
                            }
                          },
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDatePicker(
                                  selectedTime: updateJoinDate,
                                  joinDate: true,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Icon(
                          CupertinoIcons.arrow_right,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: CustomTextFormField(
                          hint: 'End Date',
                          prefixIcon: Icons.today,
                          readOnly: true,
                          textEditingController: endDateController,
                          textStyle:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                          validator: (value){
                            setState(() {
                              endDate = endDate;
                            });
                            return null;
                          },
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDatePicker(
                                  selectedTime: updateEndDate,
                                  joinDate: false,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black12,
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  buttonText: 'Cancel',
                  buttonColor: AppColors.buttonLight,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                CustomButton(
                  buttonText: 'Save',
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      employeeModel = EmployeeModel(
                        employeeID: employeeID,
                        name: employeeName,
                        role: role,
                        joinDate: joinDate,
                        endDate: endDate,
                      );
                      context
                          .read<EmployeeBloc>()
                          .add(AddEmployee(employeeModel));
                      context.read<EmployeeBloc>().add(LoadEmployees());
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
