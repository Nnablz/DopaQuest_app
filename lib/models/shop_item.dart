import 'package:hive/hive.dart';

class ShopItem {
  final String id;
  final String name;
  final int cost;
  final int iconCodePoint;
  final int colorValue;

  ShopItem({
    required this.id,
    required this.name,
    required this.cost,
    required this.iconCodePoint,
    required this.colorValue,
  });

  ShopItem copyWith({
    String? id,
    String? name,
    int? cost,
    int? iconCodePoint,
    int? colorValue,
  }) {
    return ShopItem(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}

class ShopItemAdapter extends TypeAdapter<ShopItem> {
  @override
  final int typeId = 2; // Unique ID for ShopItem

  @override
  ShopItem read(BinaryReader reader) {
    return ShopItem(
      id: reader.readString(),
      name: reader.readString(),
      cost: reader.readInt(),
      iconCodePoint: reader.readInt(),
      colorValue: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ShopItem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeInt(obj.cost);
    writer.writeInt(obj.iconCodePoint);
    writer.writeInt(obj.colorValue);
  }
}
