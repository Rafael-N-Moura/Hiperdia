// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 0;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      image: fields[0] as String,
      name: fields[1] as String,
      dateBirthday: fields[2] as String,
      cpf: fields[3] as String,
      susCard: fields[4] as String,
      motherName: fields[5] as String,
      agentName: fields[6] as String,
      extraInfo: fields[7] as String,
      disease: fields[8] as String,
      risk: fields[9] as String,
      hospitalization: fields[10] as bool,
      death: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dateBirthday)
      ..writeByte(3)
      ..write(obj.cpf)
      ..writeByte(4)
      ..write(obj.susCard)
      ..writeByte(5)
      ..write(obj.motherName)
      ..writeByte(6)
      ..write(obj.agentName)
      ..writeByte(7)
      ..write(obj.extraInfo)
      ..writeByte(8)
      ..write(obj.disease)
      ..writeByte(9)
      ..write(obj.risk)
      ..writeByte(10)
      ..write(obj.hospitalization)
      ..writeByte(11)
      ..write(obj.death);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
