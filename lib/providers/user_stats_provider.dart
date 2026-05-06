import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user_stats.dart';

class UserStatsNotifier extends Notifier<UserStats> {
  @override
  UserStats build() {
    var box = Hive.box<UserStats>('userStatsBox');
    if (box.isNotEmpty) {
      return box.get('stats')!;
    } else {
      var initialStats = UserStats(hp: 100, xp: 0, level: 1, gold: 0);
      box.put('stats', initialStats);
      return initialStats;
    }
  }

  void addXp(int amount) {
    int newXp = state.xp + amount;
    int newLevel = state.level;
    while (newXp >= newLevel * 100) {
      newXp -= newLevel * 100;
      newLevel++;
    }
    state = state.copyWith(xp: newXp, level: newLevel);
    _saveToHive();
  }

  void removeXp(int amount) {
    int newXp = state.xp - amount;
    int newLevel = state.level;
    
    while (newXp < 0 && newLevel > 1) {
      newLevel--;
      newXp += newLevel * 100; 
    }
    
    if (newXp < 0) newXp = 0;

    state = state.copyWith(xp: newXp, level: newLevel);
    _saveToHive();
  }

  void addGold(int amount) {
    state = state.copyWith(gold: state.gold + amount);
    _saveToHive();
  }

  void spendGold(int amount) {
    if (state.gold >= amount) {
      state = state.copyWith(gold: state.gold - amount);
      _saveToHive();
    }
  }

  void removeGold(int amount) {
    int newGold = state.gold - amount;
    if (newGold < 0) newGold = 0;
    state = state.copyWith(gold: newGold);
    _saveToHive();
  }

  void takeDamage(int amount) {
    int newHp = state.hp - amount;
    if (newHp < 0) newHp = 0;
    state = state.copyWith(hp: newHp);
    _saveToHive();
  }

  void heal(int amount) {
    int newHp = state.hp + amount;
    if (newHp > 100) newHp = 100;
    state = state.copyWith(hp: newHp);
    _saveToHive();
  }

  void _saveToHive() {
    var box = Hive.box<UserStats>('userStatsBox');
    box.put('stats', state);
  }
}

final userStatsProvider = NotifierProvider<UserStatsNotifier, UserStats>(() {
  return UserStatsNotifier();
});
