import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/memory_card.dart';
import 'memory_details_screen.dart';

class OnThisDayScreen extends StatelessWidget {
  const OnThisDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();
    final memories = provider.onThisDayMemories;
    final now = DateTime.now();

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('في مثل هذا اليوم'),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF75520C),
                    Color(0xFFD4A13C),
                  ],
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ذكريات هذا التاريخ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${now.day}/${now.month} من السنوات السابقة',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (memories.isEmpty)
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.history_toggle_off_rounded,
                title: 'لا توجد ذكرى في هذا اليوم بعد',
                message:
                    'عندما يمر عام على أي ذكرى محفوظة في هذا التاريخ، ستظهر هنا تلقائياً.',
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
            sliver: SliverList.separated(
              itemCount: memories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final memory = memories[index];
                final yearsAgo = now.year - memory.date.year;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      yearsAgo == 1
                          ? 'قبل سنة'
                          : 'قبل $yearsAgo سنوات',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    MemoryCard(
                      memory: memory,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                MemoryDetailsScreen(memoryId: memory.id),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
