import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest.dart';
import '../providers/quests_provider.dart';
import '../providers/user_stats_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

class QuestCard extends ConsumerWidget {
  final Quest quest;

  const QuestCard({super.key, required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Dismissible(
      key: Key(quest.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final stats = ref.read(userStatsProvider);
        if (stats.gold < 100) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not enough Gold! You need 100 Gold to delete a quest.'),
              backgroundColor: Colors.redAccent,
            ),
          );
          return false;
        }

        final bool? confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Quest?'),
              content: const Text('Deleting this quest will cost 100 Gold. Are you sure?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete (-100 Gold)', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          ref.read(userStatsProvider.notifier).spendGold(100);
          return true;
        }
        return false;
      },
      onDismissed: (direction) {
        ref.read(questsProvider.notifier).removeQuest(quest.id);
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white, size: 32),
      ),
      child: GestureDetector(
        onTap: () async {
          if (!quest.isCompleted && quest.requiresPhoto) {
            final source = await showModalBottomSheet<ImageSource>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder: (context) => SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Verify Quest', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Take a Photo'),
                      onTap: () => Navigator.pop(context, ImageSource.camera),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Choose from Gallery'),
                      onTap: () => Navigator.pop(context, ImageSource.gallery),
                    ),
                  ],
                ),
              ),
            );

            if (source == null) return; // User dismissed bottom sheet

            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: source);
            if (image == null) {
              // User cancelled taking photo/picking from gallery
              return;
            }
          }
          ref.read(questsProvider.notifier).toggleQuest(quest.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: quest.isCompleted ? Colors.tealAccent.withValues(alpha: 0.15) : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: quest.isCompleted ? Colors.tealAccent.shade400 : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: quest.isCompleted
                    ? Colors.tealAccent.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: quest.isCompleted ? 20 : 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: quest.isCompleted ? Colors.tealAccent.shade400 : Colors.grey.withValues(alpha: 0.2),
                ),
                child: quest.isCompleted
                    ? const Icon(Icons.check, color: Colors.black87, size: 20)
                        .animate()
                        .scale(duration: 300.ms, curve: Curves.easeOutBack)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          quest.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                            color: quest.isCompleted ? textColor.withValues(alpha: 0.5) : textColor,
                          ),
                        ),
                        if (quest.requiresPhoto && !quest.isCompleted) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.camera_alt, size: 16, color: Colors.grey),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '+${quest.baseXp} XP',
                          style: TextStyle(
                            color: Colors.blueAccent.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '+${quest.baseGold} Gold',
                          style: TextStyle(
                            color: Colors.amber.shade400,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
