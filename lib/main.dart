import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/quest.dart';
import 'models/user_stats.dart';
import 'models/shop_item.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(UserStatsAdapter());
  Hive.registerAdapter(QuestAdapter());
  Hive.registerAdapter(ShopItemAdapter());

  await Hive.openBox('settingsBox');
  await Hive.openBox<UserStats>('userStatsBox');
  await Hive.openBox<Quest>('questsBox');
  await Hive.openBox<ShopItem>('shopItemsBox');

  runApp(const ProviderScope(child: DopaQuestApp()));
}

class DopaQuestApp extends ConsumerWidget {
  const DopaQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'DopaQuest',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent).copyWith(
          secondary: Colors.pinkAccent,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent, brightness: Brightness.dark).copyWith(
          secondary: Colors.pinkAccent,
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
