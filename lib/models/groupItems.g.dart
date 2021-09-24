// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupItems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupItemsAdapter extends TypeAdapter<GroupItems> {
  @override
  final int typeId = 1;

  @override
  GroupItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupItems(
      (fields[1] as List)?.cast<String>(),
      (fields[2] as List)?.cast<String>(),
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GroupItems obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dirPath?.toList())
      ..writeByte(2)
      ..write(obj.filePath?.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
