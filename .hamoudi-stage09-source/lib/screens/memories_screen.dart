import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/memory_entry.dart';
import '../providers/memory_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import 'add_memory_screen.dart';
import 'memory_details_screen.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();
    final memories = _tab == 0 ? provider.memories : provider.onThisDayMemories;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF43B7F5), Color(0xFFEAF8FF), Colors.white],
            stops: [0, 0.30, 1],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                sliver: SliverToBoxAdapter(
                  child: _MemoryHeader(name: provider.profile.name),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverToBoxAdapter(
                  child: _SegmentedTabs(
                    selected: _tab,
                    onChanged: (value) => setState(() => _tab = value),
                  ),
                ),
              ),
              if (_tab == 1)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  sliver: SliverToBoxAdapter(
                    child: _OnThisDayCard(count: provider.onThisDayMemories.length),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  sliver: SliverToBoxAdapter(
                    child: _StatsRow(
                      photos: provider.memories.where((m) => m.imagePath?.isNotEmpty == true).length,
                      videos: provider.videoCount,
                      total: provider.memories.length,
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              if (memories.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                  sliver: SliverToBoxAdapter(
                    child: EmptyState(
                      icon: _tab == 0 ? Icons.collections_bookmark_rounded : Icons.history_toggle_off_rounded,
                      title: _tab == 0 ? 'لا توجد ذكريات بعد' : 'لا توجد ذكرى في هذا اليوم',
                      message: _tab == 0
                          ? 'أضف أول لحظة جميلة لتبدأ حكاية حمودي.'
                          : 'ستظهر هنا الذكريات التي حدثت في نفس تاريخ اليوم.',
                      actionLabel: _tab == 0 && provider.canEditActiveChild ? 'إضافة ذكرى' : null,
                      onAction: _tab == 0 && provider.canEditActiveChild
                          ? () => _openAdd(context)
                          : null,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
                  sliver: SliverList.builder(
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      return _TimelineMemoryCard(
                        memory: memories[index],
                        index: index,
                        isLast: index == memories.length - 1,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => MemoryDetailsScreen(memoryId: memories[index].id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: provider.canEditActiveChild
          ? FloatingActionButton.extended(
              onPressed: () => _openAdd(context),
              backgroundColor: KidPalette.sky,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: const Text('إضافة ذكرى جديدة', style: TextStyle(fontWeight: FontWeight.w900)),
            )
          : null,
    );
  }

  void _openAdd(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AddMemoryScreen()));
  }
}

class _MemoryHeader extends StatelessWidget {
  const _MemoryHeader({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                color: Colors.white.withValues(alpha: 0.94),
                border: Border.all(color: Colors.white, width: 4),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 28,
            left: 170,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ذكرياتي', style: TextStyle(color: KidPalette.navy, fontSize: 34, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('لحظات $name التي لا تُنسى...\nنحتفظ بها معاً 💗', style: const TextStyle(color: KidPalette.navy, height: 1.45, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Positioned(
            left: -4,
            bottom: -22,
            child: Image.asset('assets/icon/hamoodi_icon.jpg', width: 190, height: 190, fit: BoxFit.cover),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: KidPalette.skyDark),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Expanded(child: _TabButton(label: 'ذكرياتي', icon: Icons.collections_bookmark_rounded, selected: selected == 0, color: KidPalette.sky, onTap: () => onChanged(0))),
          const SizedBox(width: 6),
          Expanded(child: _TabButton(label: 'في مثل هذا اليوم', icon: Icons.calendar_month_rounded, selected: selected == 1, color: KidPalette.lavender, onTap: () => onChanged(1))),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.icon, required this.selected, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? Colors.white : KidPalette.navy, size: 21),
              const SizedBox(width: 7),
              Flexible(child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : KidPalette.navy, fontWeight: FontWeight.w900))),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnThisDayCard extends StatelessWidget {
  const _OnThisDayCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: KidPalette.coral,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Row(
        children: [
          Container(
            width: 86,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                Text(DateFormat('EEEE', 'ar').format(now), style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w800)),
                Text('${now.day}', style: const TextStyle(color: KidPalette.skyDark, fontSize: 36, fontWeight: FontWeight.w900)),
                Text(DateFormat('MMMM', 'ar').format(now), style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('في مثل هذا اليوم', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                Text(count == 0 ? 'سننتظر حتى تعود لنا ذكرى جميلة.' : 'وجدنا $count ذكريات جميلة من السنوات السابقة!', style: const TextStyle(color: Colors.white, height: 1.4, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Text('🎈', style: TextStyle(fontSize: 34)),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.photos, required this.videos, required this.total});
  final int photos;
  final int videos;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: KidPalette.mint.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(26), border: Border.all(color: Colors.white, width: 4)),
      child: Row(
        children: [
          Expanded(child: _Stat(icon: Icons.photo_camera_rounded, value: photos, label: 'صورة')),
          Expanded(child: _Stat(icon: Icons.videocam_rounded, value: videos, label: 'فيديو')),
          Expanded(child: _Stat(icon: Icons.star_rounded, value: total, label: 'ذكريات')),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: KidPalette.navy),
        Text('$value', style: const TextStyle(color: KidPalette.navy, fontSize: 21, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _TimelineMemoryCard extends StatelessWidget {
  const _TimelineMemoryCard({required this.memory, required this.index, required this.isLast, required this.onTap});
  final MemoryEntry memory;
  final int index;
  final bool isLast;
  final VoidCallback onTap;

  static const colors = [KidPalette.sunshine, KidPalette.mint, KidPalette.coral, KidPalette.lavender, KidPalette.sky, KidPalette.pink];

  @override
  Widget build(BuildContext context) {
    final color = colors[index % colors.length];
    final imagePath = memory.imagePath;
    final hasImage = imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync();

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 42,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                  child: const Icon(Icons.star_rounded, color: Colors.white, size: 19),
                ),
                if (!isLast) Expanded(child: Container(width: 3, color: color.withValues(alpha: 0.55))),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Material(
                color: color.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(26),
                elevation: 4,
                child: InkWell(
                  borderRadius: BorderRadius.circular(26),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: SizedBox(
                            width: 82,
                            height: 82,
                            child: hasImage
                                ? Image.file(File(imagePath), fit: BoxFit.cover)
                                : ColoredBox(color: Colors.white.withValues(alpha: 0.65), child: Center(child: Text(memory.type.emoji, style: const TextStyle(fontSize: 37)))),
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(memory.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: KidPalette.navy, fontSize: 18, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text(memory.type.labelAr, style: const TextStyle(color: KidPalette.navy, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(DateFormat('d MMMM y', 'ar').format(memory.date), style: TextStyle(color: KidPalette.navy.withValues(alpha: 0.78), fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        if (memory.isFavorite) const Icon(Icons.favorite_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
