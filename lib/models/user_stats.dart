import 'package:hive/hive.dart';

class UserStats {
  int hp; // max 100
  int xp;
  int level;
  int gold;

  UserStats({
    required this.hp,
    required this.xp,
    required this.level,
    required this.gold,
  });

  UserStats copyWith({int? hp, int? xp, int? level, int? gold}) {
    return UserStats(
      hp: hp ?? this.hp,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      gold: gold ?? this.gold,
    );
  }
}

class UserStatsAdapter extends TypeAdapter<UserStats> {
  @override
  final int typeId = 0;

  @override
  UserStats read(BinaryReader reader) {
    return UserStats(
      hp: reader.readInt(),
      xp: reader.readInt(),
      level: reader.readInt(),
      gold: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer.writeInt(obj.hp);
    writer.writeInt(obj.xp);
    writer.writeInt(obj.level);
    writer.writeInt(obj.gold);
  }
}
