// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_ressource_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedRessourceListAdapter extends TypeAdapter<SavedRessourceList> {
  @override
  final int typeId = 2;

  @override
  SavedRessourceList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedRessourceList(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      image: fields[3] as String,
      type: (fields[4] as List?)?.cast<Types>(),
      followLink: fields[5] as String,
      localLink: fields[6] as String,
      niveau: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedRessourceList obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.followLink)
      ..writeByte(6)
      ..write(obj.localLink)
      ..writeByte(7)
      ..write(obj.niveau);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedRessourceListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
