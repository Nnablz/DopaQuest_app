import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/quest.dart';
import 'user_stats_provider.dart';

class QuestsNotifier extends Notifier<List<Quest>> {
  @override
  List<Quest> build() {
    var box = Hive.box<Quest>('questsBox');
    var settingsBox = Hive.box('settingsBox');
    
    var lastLoginString = settingsBox.get('lastLoginDate');
    var now = DateTime.now();
    var isNewDay = false;

    if (lastLoginString != null) {
      var lastLogin = DateTime.parse(lastLoginString);
      if (lastLogin.year != now.year || lastLogin.month != now.month || lastLogin.day != now.day) {
        isNewDay = true;
      }
    } else {
      isNewDay = true;
    }

    settingsBox.put('lastLoginDate', now.toIso8601String());

    if (box.isEmpty) {
      var initialQuests = [
        Quest(id: '1', name: 'Drink Water', frequency: 'Daily', baseXp: 10, baseGold: 5),
        Quest(id: '2', name: 'Read 10 Pages', frequency: 'Daily', baseXp: 20, baseGold: 10),
        Quest(id: '3', name: 'Workout', frequency: 'Daily', baseXp: 50, baseGold: 25),
      ];
      box.addAll(initialQuests);
      return initialQuests;
    } else {
      var quests = box.values.toList();
      if (isNewDay) {
        var updatedQuests = <Quest>[];
        for (var i = 0; i < quests.length; i++) {
          var updated = quests[i].copyWith(isCompleted: false);
          updatedQuests.add(updated);
          var key = box.keyAt(i);
          box.put(key, updated);
        }
        return updatedQuests;
      }
      return quests;
    }
  }

  void toggleQuest(String id) {
    var questIndex = state.indexWhere((q) => q.id == id);
    if (questIndex != -1) {
      var quest = state[questIndex];
      var newStatus = !quest.isCompleted;
      
      var updatedQuest = quest.copyWith(isCompleted: newStatus);
      var newState = [...state];
      newState[questIndex] = updatedQuest;
      state = newState;
      
      var box = Hive.box<Quest>('questsBox');
      var key = box.keys.firstWhere((k) => box.get(k)?.id == id, orElse: () => null);
      if (key != null) {
        box.put(key, updatedQuest);
      }

      var statsNotifier = ref.read(userStatsProvider.notifier);
      if (newStatus) {
        statsNotifier.addXp(quest.baseXp);
        statsNotifier.addGold(quest.baseGold);
      } else {
        statsNotifier.removeXp(quest.baseXp);
        statsNotifier.removeGold(quest.baseGold);
      }
    }
  }

  void addQuest(Quest quest) {
    state = [...state, quest];
    var box = Hive.box<Quest>('questsBox');
    box.add(quest);
  }

  void removeQuest(String id) {
    state = state.where((q) => q.id != id).toList();
    var box = Hive.box<Quest>('questsBox');
    var key = box.keys.firstWhere((k) => box.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      box.delete(key);
    }
  }

  void checkDailyReset() {
    var settingsBox = Hive.box('settingsBox');
    var lastLoginString = settingsBox.get('lastLoginDate');
    var now = DateTime.now();

    if (lastLoginString != null) {
      var lastLogin = DateTime.parse(lastLoginString);
      if (lastLogin.year != now.year || lastLogin.month != now.month || lastLogin.day != now.day) {
        var box = Hive.box<Quest>('questsBox');
        var updatedQuests = <Quest>[];
        for (var quest in state) {
          var updated = quest.copyWith(isCompleted: false);
          updatedQuests.add(updated);
          var key = box.keys.firstWhere((k) => box.get(k)?.id == quest.id, orElse: () => null);
          if (key != null) {
            box.put(key, updated);
          }
        }
        state = updatedQuests;
        settingsBox.put('lastLoginDate', now.toIso8601String());
      }
    }
  }
}

final questsProvider = NotifierProvider<QuestsNotifier, List<Quest>>(() {
  return QuestsNotifier();
});
