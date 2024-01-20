import 'package:equatable/equatable.dart';
import 'package:realtime_inno_test/model/employeeModel.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddEmployee extends EmployeeEvent {
  final EmployeeModel employee;

  AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployee extends EmployeeEvent {
  final EmployeeModel employee;

  UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmployee extends EmployeeEvent {
  final String employeeId;

  DeleteEmployee(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class LoadEmployees extends EmployeeEvent {}

// Employee State
abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoadSuccess extends EmployeeState {
  final List<EmployeeModel> employees;

  EmployeeLoadSuccess(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeOperationFailure extends EmployeeState {
  final String errorMessage;

  EmployeeOperationFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}