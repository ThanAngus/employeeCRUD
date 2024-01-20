import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:realtime_inno_test/model/employeeModel.dart';
import 'crud_operation_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final Box<EmployeeModel> employeeBox;

  EmployeeBloc(this.employeeBox) : super(EmployeeLoading()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) async {
    try {
      emit(EmployeeLoadSuccess(employeeBox.values.toList()));
    } catch (e) {
      emit(
        EmployeeOperationFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onAddEmployee(
      AddEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await employeeBox.put(event.employee.employeeID, event.employee); // Add new employee
      emit(EmployeeLoadSuccess(employeeBox.values.toList())); // Emit success with updated list
    } catch (e) {
      emit(
        EmployeeOperationFailure(
          errorMessage: e.toString(),
        ),
      ); // Emit failure state in case of error
    }
  }

  Future<void> _onUpdateEmployee(UpdateEmployee event, Emitter<EmployeeState> emit) async {
    try{
      await employeeBox.put(event.employee.employeeID, event.employee).whenComplete((){
        emit(EmployeeLoadSuccess(employeeBox.values.toList()));
      });
    }catch (e) {
      emit(
        EmployeeOperationFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteEmployee(
      DeleteEmployee event, Emitter<EmployeeState> emit) async {
    try {
      await employeeBox.delete(event.employeeId).whenComplete(() {
        emit(EmployeeLoadSuccess(employeeBox.values.toList()));
      });
    } catch (e) {
      emit(
        EmployeeOperationFailure(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
