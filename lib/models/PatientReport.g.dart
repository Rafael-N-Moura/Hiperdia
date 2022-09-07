// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PatientReport.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientReportAdapter extends TypeAdapter<PatientReport> {
  @override
  final int typeId = 7;

  @override
  PatientReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatientReport(
      name: fields[0] as String,
      date: fields[1] as DateTime,
      path: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PatientReport obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
