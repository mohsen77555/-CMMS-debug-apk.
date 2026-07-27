import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'about_privacy_screen.dart';
import 'backup_restore_screen.dart';
import 'family_sharing_screen.dart';
import 'future_letters_screen.dart';
import 'memory_book_screen.dart';
import 'milestones_screen.dart';
import 'notification_settings_screen.dart';
import 'security_settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MoreItem>[
      _MoreItem('محطات النمو', 'تابع الخطوات والإنجازات', Icons.flag_circle_rounded, KidPalette.mint, const MilestonesScreen()),
      _MoreItem('رسائل المستقبل', 'رسائل تفتح في الوقت المحدد', Icons.mark_email_unread_rounded, KidPalette.lavender, const FutureLettersScreen()),
      _MoreItem('كتاب الذكريات', 'أنشئ كتاب PDF للعائلة', Icons.auto_stories_rounded, KidPalette.sunshine, const MemoryBookScreen()),
      _MoreItem('مشاركة العائلة', 'إدارة المشاركين والصلاحيات', Icons.family_restroom_rounded, KidPalette.peach, const FamilySharingScreen()),
      _MoreItem('النسخ الاحتياطي', 'حفظ واستعادة بيانات حمودي', Icons.cloud_sync_rounded, KidPalette.sky, const BackupRestoreScreen()),
      _MoreItem('الإشعارات', 'مواعيد الذكريات والرسائل', Icons.notifications_active_rounded, KidPalette.pink, const NotificationSettingsScreen()),
      _MoreItem('الأمان والخصوصية', 'قفل وبصمة وإعدادات الوالدين', Icons.lock_rounded, KidPalette.coral, const SecuritySettingsScreen()),
      _MoreItem('حول التطبيق', 'السياسات ومعلومات الإصدار', Icons.info_rounded, KidPalette.mint, const AboutPrivacyScreen()),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF8FF), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset('assets/icon/hamoodi_icon.jpg', width: 76, height: 76, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المزيد', style: TextStyle(color: KidPalette.navy, fontSize: 30, fontWeight: FontWeight.w900)),
                        Text('كل أدوات العائلة في مكان واحد', style: TextStyle(color: Color(0xFF55758B), fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  elevation: 4,
                  shadowColor: KidPalette.navy.withValues(alpha: 0.1),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => item.screen),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 27,
                            backgroundColor: item.color.withValues(alpha: 0.28),
                            child: Icon(item.icon, color: item.color, size: 29),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: const TextStyle(color: KidPalette.navy, fontSize: 18, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 4),
                                Text(item.subtitle, style: const TextStyle(color: Color(0xFF607D8D), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_left_rounded, color: KidPalette.skyDark),
                        ],
                      ),
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

class _MoreItem {
  const _MoreItem(this.title, this.subtitle, this.icon, this.color, this.screen);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;
}
