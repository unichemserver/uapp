// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cust_top.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustTopAdapter extends TypeAdapter<CustTop> {
  @override
  final int typeId = 3;

  @override
  CustTop read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustTop(
      topID: fields[0] as String,
      custID: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CustTop obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.topID)
      ..writeByte(1)
      ..write(obj.custID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustTopAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
