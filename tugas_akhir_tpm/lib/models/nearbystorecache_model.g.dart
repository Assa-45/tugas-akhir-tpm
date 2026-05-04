// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearbystorecache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NearbyStoreAdapter extends TypeAdapter<NearbyStore> {
  @override
  final int typeId = 3;

  @override
  NearbyStore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NearbyStore(
      name: fields[0] as String,
      lat: fields[1] as double,
      lng: fields[2] as double,
      distance: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, NearbyStore obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.lng)
      ..writeByte(3)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NearbyStoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
