// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitSetAdapter extends TypeAdapter<UnitSet> {
  @override
  final int typeId = 2;

  @override
  UnitSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnitSet(
      unitSetID: fields[0] as String?,
      unitID: fields[1] as String?,
      conversion: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UnitSet obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.unitSetID)
      ..writeByte(1)
      ..write(obj.unitID)
      ..writeByte(2)
      ..write(obj.conversion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
