import 'package:hive/hive.dart';

class Quest {
  String id;
  String name;
  String frequency;
  int baseXp;
  int baseGold;
  bool isCompleted;
  bool requiresPhoto;

  Quest({
    required this.id,
    required this.name,
    required this.frequency,
    required this.baseXp,
    required this.baseGold,
    this.isCompleted = false,
    this.requiresPhoto = false,
  });

  Quest copyWith({
    String? id,
    String? name,
    String? frequency,
    int? baseXp,
    int? baseGold,
    bool? isCompleted,
    bool? requiresPhoto,
  }) {
    return Quest(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      baseXp: baseXp ?? this.baseXp,
      baseGold: baseGold ?? this.baseGold,
      isCompleted: isCompleted ?? this.isCompleted,
      requiresPhoto: requiresPhoto ?? this.requiresPhoto,
    );
  }
}

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 1;

  @override
  Quest read(BinaryReader reader) {
    var id = reader.readString();
    var name = reader.readString();
    var frequency = reader.readString();
    var baseXp = reader.readInt();
    var baseGold = reader.readInt();
    var isCompleted = reader.readBool();
    
    bool requiresPhoto = false;
    if (reader.availableBytes > 0) {
      requiresPhoto = reader.readBool();
    }

    return Quest(
      id: id,
      name: name,
      frequency: frequency,
      baseXp: baseXp,
      baseGold: baseGold,
      isCompleted: isCompleted,
      requiresPhoto: requiresPhoto,
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
    writer.writeBool(obj.requiresPhoto);
  }
}
