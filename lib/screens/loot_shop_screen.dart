import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_stats_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LootShopScreen extends ConsumerWidget {
  const LootShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loot Shop', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
                  const SizedBox(width: 4),
                  Text(
                    '${stats.gold}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildShopItem(context, ref, 'Streak Freeze', Icons.ac_unit, 50, Colors.blueAccent),
          _buildShopItem(context, ref, 'Health Potion', Icons.local_drink, 30, Colors.pinkAccent),
          _buildShopItem(context, ref, 'Theme Unlock', Icons.color_lens, 100, Colors.purpleAccent),
          _buildShopItem(context, ref, 'Cheat Day', Icons.fastfood, 200, Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, WidgetRef ref, String name, IconData icon, int cost, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color).animate().shimmer(duration: 2.seconds),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              ref.read(userStatsProvider.notifier).spendGold(cost);
              if (name == 'Health Potion') {
                ref.read(userStatsProvider.notifier).heal(20);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('$cost Gold'),
          ),
        ],
      ),
    ).animate().scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }
}
