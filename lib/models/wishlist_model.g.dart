// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistModelAdapter extends TypeAdapter<WishlistModel> {
  @override
  final int typeId = 1;

  @override
  WishlistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistModel(
      idProduct: fields[0] as int,
      isFavorite: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.idProduct)
      ..writeByte(1)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
