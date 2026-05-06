import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quests_provider.dart';
import 'dashboard_screen.dart';
import 'loot_shop_screen.dart';
import 'account_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(questsProvider.notifier).checkDailyReset();
    }
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const LootShopScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Theme.of(context).cardColor,
            selectedItemColor: Colors.tealAccent.shade400,
            unselectedItemColor: Colors.grey.shade500,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                activeIcon: Icon(Icons.assignment, size: 32),
                label: 'Quests',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                activeIcon: Icon(Icons.store, size: 32),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                activeIcon: Icon(Icons.person, size: 32),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
