// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ubs.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UbsAdapter extends TypeAdapter<Ubs> {
  @override
  final int typeId = 6;

  @override
  Ubs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ubs(
      date: fields[0] as String,
      professional: fields[1] as String,
      professionalName: fields[2] as String,
      place: fields[3] as String,
      id: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ubs obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.professional)
      ..writeByte(2)
      ..write(obj.professionalName)
      ..writeByte(3)
      ..write(obj.place)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UbsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
