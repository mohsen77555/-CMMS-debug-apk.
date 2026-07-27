import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/parent_gate.dart';
import 'add_memory_screen.dart';
import 'favorites_screen.dart';
import 'games_hub_screen.dart';
import 'home_screen.dart';
import 'more_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 2;

  final _pages = const [
    MoreScreen(),
    GamesHubScreen(),
    HomeScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  Future<void> _selectDestination(int index) async {
    if (index == 4 && _selectedIndex != 4) {
      final allowed = await ParentGate.confirm(context);
      if (!allowed || !mounted) return;
    }
    setState(() => _selectedIndex = index);
  }

  void _openAddMemory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddMemoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      floatingActionButton: _selectedIndex == 2 && provider.canEditActiveChild
          ? FloatingActionButton.extended(
              onPressed: _openAddMemory,
              backgroundColor: KidPalette.sky,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text(
                'إضافة ذكرى',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.star_outline_rounded),
            selectedIcon: Icon(Icons.star_rounded, color: KidPalette.sunshine),
            label: 'المزيد',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports_rounded, color: KidPalette.lavender),
            label: 'ألعاب',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: KidPalette.skyDark),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded, color: KidPalette.coral),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.child_care_outlined),
            selectedIcon: Icon(Icons.child_care_rounded, color: KidPalette.mint),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
