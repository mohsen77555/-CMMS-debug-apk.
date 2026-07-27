import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/memory_card.dart';
import 'memory_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();
    final memories = provider.favoriteMemories;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFEAF0), Color(0xFFF4FBFF), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('المفضلة'),
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.favorite_rounded, color: KidPalette.coral),
              ),
            ),
          ),
          if (memories.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 32, 20, 120),
              sliver: SliverToBoxAdapter(
                child: EmptyState(
                  icon: Icons.favorite_border_rounded,
                  title: 'لا توجد ذكريات مفضلة بعد',
                  message: 'ضع علامة القلب على أجمل الذكريات لتظهر هنا.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              sliver: SliverList.separated(
                itemCount: memories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return MemoryCard(
                    memory: memory,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MemoryDetailsScreen(memoryId: memory.id),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
