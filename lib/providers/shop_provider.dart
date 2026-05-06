import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/shop_item.dart';

class ShopNotifier extends Notifier<List<ShopItem>> {
  @override
  List<ShopItem> build() {
    var box = Hive.box<ShopItem>('shopItemsBox');
    return box.values.toList();
  }

  void addShopItem(ShopItem item) {
    state = [...state, item];
    var box = Hive.box<ShopItem>('shopItemsBox');
    box.add(item);
  }

  void removeShopItem(String id) {
    state = state.where((item) => item.id != id).toList();
    var box = Hive.box<ShopItem>('shopItemsBox');
    var key = box.keys.firstWhere((k) => box.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      box.delete(key);
    }
  }
}

final shopProvider = NotifierProvider<ShopNotifier, List<ShopItem>>(() {
  return ShopNotifier();
});
