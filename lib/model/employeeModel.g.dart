// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employeeModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeModelAdapter extends TypeAdapter<EmployeeModel> {
  @override
  final int typeId = 0;

  @override
  EmployeeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeModel(
      employeeID: fields[0] as String,
      name: fields[1] as String,
      role: fields[2] as Roles,
      joinDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.employeeID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.joinDate)
      ..writeByte(4)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RolesAdapter extends TypeAdapter<Roles> {
  @override
  final int typeId = 1;

  @override
  Roles read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Roles.productDesigner;
      case 1:
        return Roles.flutterDeveloper;
      case 2:
        return Roles.qaTester;
      case 3:
        return Roles.productOwner;
      default:
        return Roles.productDesigner;
    }
  }

  @override
  void write(BinaryWriter writer, Roles obj) {
    switch (obj) {
      case Roles.productDesigner:
        writer.writeByte(0);
        break;
      case Roles.flutterDeveloper:
        writer.writeByte(1);
        break;
      case Roles.qaTester:
        writer.writeByte(2);
        break;
      case Roles.productOwner:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RolesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
