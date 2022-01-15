// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Hospitalization.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HospitalizationAdapter extends TypeAdapter<Hospitalization> {
  @override
  final int typeId = 5;

  @override
  Hospitalization read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hospitalization(
      id: fields[0] as String,
      cause: fields[1] as String,
      place: fields[2] as String,
      dateStart: fields[3] as String,
      dateEnd: fields[4] as String,
      key: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hospitalization obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cause)
      ..writeByte(2)
      ..write(obj.place)
      ..writeByte(3)
      ..write(obj.dateStart)
      ..writeByte(4)
      ..write(obj.dateEnd)
      ..writeByte(5)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalizationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
