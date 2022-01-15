// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Obito.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ObitoAdapter extends TypeAdapter<Obito> {
  @override
  final int typeId = 2;

  @override
  Obito read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Obito(
      id: fields[0] as String,
      date: fields[1] as String,
      cause: fields[2] as String,
      data: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Obito obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.cause)
      ..writeByte(3)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObitoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
