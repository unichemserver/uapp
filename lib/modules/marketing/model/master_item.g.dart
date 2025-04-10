// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MasterItemAdapter extends TypeAdapter<MasterItem> {
  @override
  final int typeId = 1;

  @override
  MasterItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MasterItem(
      itemID: fields[0] as String?,
      description: fields[1] as String?,
      salesUnit: fields[2] as String?,
      salesPrice: fields[3] as String?,
      unitSetID: fields[4] as String?,
      taxGroupID: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MasterItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.itemID)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.salesUnit)
      ..writeByte(3)
      ..write(obj.salesPrice)
      ..writeByte(4)
      ..write(obj.unitSetID)
      ..writeByte(5)
      ..write(obj.taxGroupID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
