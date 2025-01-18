// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PriceListAdapter extends TypeAdapter<PriceList> {
  @override
  final int typeId = 4;

  @override
  PriceList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PriceList(
      itemID: fields[0] as String?,
      unitID: fields[1] as String?,
      qty: fields[2] as String?,
      unitPrice: fields[3] as String?,
      topID: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PriceList obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.itemID)
      ..writeByte(1)
      ..write(obj.unitID)
      ..writeByte(2)
      ..write(obj.qty)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.topID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
