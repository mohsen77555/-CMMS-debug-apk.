import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../services/kid_audio_service.dart';
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
    await KidAudioService.instance.tap();
    if (index == 4 && _selectedIndex != 4) {
      final allowed = await ParentGate.confirm(context);
      if (!allowed || !mounted) return;
    }
    setState(() => _selectedIndex = index);
  }

  void _openAddMemory() {
    KidAudioService.instance.sparkle();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AddMemoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();
    const icons = [
      Icons.star_rounded,
      Icons.sports_esports_rounded,
      Icons.home_rounded,
      Icons.favorite_rounded,
      Icons.lock_rounded,
    ];
    const colors = [
      KidPalette.sunshine,
      KidPalette.lavender,
      KidPalette.sky,
      KidPalette.pink,
      KidPalette.mint,
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      floatingActionButton: _selectedIndex == 2 && provider.canEditActiveChild
          ? FloatingActionButton.large(
              onPressed: _openAddMemory,
              backgroundColor: KidPalette.coral,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_a_photo_rounded, size: 34),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 82,
          margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF1),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3300264D),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              final selected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => _selectDestination(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: selected ? 62 : 52,
                  height: selected ? 62 : 52,
                  decoration: BoxDecoration(
                    color: selected
                        ? colors[index].withValues(alpha: 0.23)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: colors[index], width: 3)
                        : null,
                  ),
                  child: Icon(
                    icons[index],
                    color: selected ? colors[index] : const Color(0xFF4A6880),
                    size: selected ? 34 : 29,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
