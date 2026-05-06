import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quests_provider.dart';
import '../widgets/stats_header.dart';
import '../widgets/quest_card.dart';
import '../widgets/add_quest_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const AddQuestDialog(),
          );
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: StatsHeader(),
            ).animate().slideY(begin: -0.2, curve: Curves.easeOut).fadeIn(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: quests.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: QuestCard(quest: quests[index])
                        .animate()
                        .slideX(begin: 0.1, delay: Duration(milliseconds: 100 * index))
                        .fadeIn(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
