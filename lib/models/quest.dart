import 'package:hive/hive.dart';

class Quest {
  String id;
  String name;
  String frequency;
  int baseXp;
  int baseGold;
  bool isCompleted;

  Quest({
    required this.id,
    required this.name,
    required this.frequency,
    required this.baseXp,
    required this.baseGold,
    this.isCompleted = false,
  });

  Quest copyWith({
    String? id,
    String? name,
    String? frequency,
    int? baseXp,
    int? baseGold,
    bool? isCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      baseXp: baseXp ?? this.baseXp,
      baseGold: baseGold ?? this.baseGold,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 1;

  @override
  Quest read(BinaryReader reader) {
    return Quest(
      id: reader.readString(),
      name: reader.readString(),
      frequency: reader.readString(),
      baseXp: reader.readInt(),
      baseGold: reader.readInt(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.frequency);
    writer.writeInt(obj.baseXp);
    writer.writeInt(obj.baseGold);
    writer.writeBool(obj.isCompleted);
  }
}
