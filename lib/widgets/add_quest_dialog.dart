import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest.dart';
import '../providers/quests_provider.dart';

class AddQuestDialog extends ConsumerStatefulWidget {
  const AddQuestDialog({super.key});

  @override
  ConsumerState<AddQuestDialog> createState() => _AddQuestDialogState();
}

class _AddQuestDialogState extends ConsumerState<AddQuestDialog> {
  final _nameController = TextEditingController();
  final _xpController = TextEditingController(text: '10');
  final _goldController = TextEditingController(text: '5');
  bool _requiresPhoto = false;

  @override
  void dispose() {
    _nameController.dispose();
    _xpController.dispose();
    _goldController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;

    final name = _nameController.text.trim();
    final xp = int.tryParse(_xpController.text) ?? 10;
    final gold = int.tryParse(_goldController.text) ?? 5;

    final newQuest = Quest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      frequency: 'Daily',
      baseXp: xp,
      baseGold: gold,
      requiresPhoto: _requiresPhoto,
    );

    ref.read(questsProvider.notifier).addQuest(newQuest);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'New Quest',
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Quest Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              prefixIcon: const Icon(Icons.title),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _xpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Base XP',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    prefixIcon: const Icon(Icons.star, color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _goldController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Base Gold',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    prefixIcon: const Icon(Icons.monetization_on, color: Colors.amber),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Require Photo Verification'),
            subtitle: const Text('Must take a photo to complete'),
            value: _requiresPhoto,
            onChanged: (val) {
              setState(() {
                _requiresPhoto = val;
              });
            },
            secondary: const Icon(Icons.camera_alt),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Theme.of(context).cardColor,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.tealAccent.shade400,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('ADD QUEST', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
