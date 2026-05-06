import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shop_item.dart';
import '../providers/shop_provider.dart';

class AddShopItemDialog extends ConsumerStatefulWidget {
  const AddShopItemDialog({super.key});

  @override
  ConsumerState<AddShopItemDialog> createState() => _AddShopItemDialogState();
}

class _AddShopItemDialogState extends ConsumerState<AddShopItemDialog> {
  final _nameController = TextEditingController();
  final _costController = TextEditingController(text: '50');

  IconData _selectedIcon = Icons.star;
  Color _selectedColor = Colors.blueAccent;

  final List<IconData> _iconOptions = [
    Icons.star,
    Icons.fastfood,
    Icons.tv,
    Icons.sports_esports,
    Icons.music_note,
    Icons.local_cafe,
    Icons.shopping_bag,
    Icons.flight,
  ];

  final List<Color> _colorOptions = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.amber,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final name = _nameController.text.trim();
    final cost = int.tryParse(_costController.text) ?? 50;

    if (name.isEmpty) return;

    final newItem = ShopItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      cost: cost,
      iconCodePoint: _selectedIcon.codePoint,
      colorValue: _selectedColor.value,
    );

    ref.read(shopProvider.notifier).addShopItem(newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Custom Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Reward Name',
                hintText: 'e.g., Watch Anime',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Gold Cost',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const Text('Select Icon:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _iconOptions.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2) : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Select Color:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colorOptions.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                      boxShadow: isSelected
                          ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: const Text('Add Item'),
        ),
      ],
    );
  }
}
