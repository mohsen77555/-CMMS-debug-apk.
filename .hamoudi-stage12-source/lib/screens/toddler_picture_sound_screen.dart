import 'package:flutter/material.dart';

import '../services/toddler_audio_service.dart';
import '../theme/app_theme.dart';

enum ToddlerCategory { animals, colors, fruits, shapes }

class ToddlerPictureSoundScreen extends StatefulWidget {
  const ToddlerPictureSoundScreen({required this.category, super.key});

  final ToddlerCategory category;

  @override
  State<ToddlerPictureSoundScreen> createState() =>
      _ToddlerPictureSoundScreenState();
}

class _ToddlerPictureSoundScreenState
    extends State<ToddlerPictureSoundScreen> {
  int _selectedIndex = 0;

  List<_ToddlerItem> get _items => switch (widget.category) {
        ToddlerCategory.animals => const [
            _ToddlerItem('🦁', 'lion.wav', KidPalette.sunshine),
            _ToddlerItem('🐱', 'cat.wav', KidPalette.pink),
            _ToddlerItem('🐶', 'dog.wav', KidPalette.peach),
            _ToddlerItem('🐘', 'elephant.wav', KidPalette.lavender),
            _ToddlerItem('🐦', 'bird.wav', KidPalette.sky),
          ],
        ToddlerCategory.colors => const [
            _ToddlerItem('🔴', 'red.wav', Color(0xFFFF625B)),
            _ToddlerItem('🔵', 'blue.wav', Color(0xFF3AAAF4)),
            _ToddlerItem('🟡', 'yellow.wav', Color(0xFFFFC93F)),
            _ToddlerItem('🟢', 'green.wav', Color(0xFF4FD09A)),
            _ToddlerItem('🟣', 'purple.wav', Color(0xFFA777E8)),
          ],
        ToddlerCategory.fruits => const [
            _ToddlerItem('🍎', 'apple.wav', KidPalette.coral),
            _ToddlerItem('🍌', 'banana.wav', KidPalette.sunshine),
            _ToddlerItem('🍓', 'strawberry.wav', KidPalette.pink),
            _ToddlerItem('🍇', 'grapes.wav', KidPalette.lavender),
            _ToddlerItem('🍊', 'orange.wav', KidPalette.peach),
          ],
        ToddlerCategory.shapes => const [
            _ToddlerItem('●', 'circle.wav', KidPalette.sky),
            _ToddlerItem('■', 'square.wav', KidPalette.coral),
            _ToddlerItem('▲', 'triangle.wav', KidPalette.sunshine),
            _ToddlerItem('★', 'star.wav', KidPalette.lavender),
            _ToddlerItem('♥', 'heart.wav', KidPalette.pink),
          ],
      };

  Color get _pageColor => switch (widget.category) {
        ToddlerCategory.animals => KidPalette.mint,
        ToddlerCategory.colors => KidPalette.sky,
        ToddlerCategory.fruits => KidPalette.sunshine,
        ToddlerCategory.shapes => KidPalette.lavender,
      };

  String get _tinyTitle => switch (widget.category) {
        ToddlerCategory.animals => 'الحيوانات',
        ToddlerCategory.colors => 'الألوان',
        ToddlerCategory.fruits => 'الفواكه',
        ToddlerCategory.shapes => 'الأشكال',
      };

  Future<void> _playSelected() async {
    await ToddlerAudioService.instance.play(_items[_selectedIndex].audioFile);
  }

  Future<void> _select(int index) async {
    setState(() => _selectedIndex = index);
    await _playSelected();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _items[_selectedIndex];

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF082E59),
              _pageColor.withValues(alpha: 0.88),
              const Color(0xFFF8FCFF),
            ],
            stops: const [0, 0.42, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                child: Row(
                  children: [
                    _CircleAction(
                      icon: Icons.arrow_back_rounded,
                      color: KidPalette.sky,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF082E59),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        _tinyTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: KidPalette.sunshine, width: 3),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/icon/hamoodi_icon.jpg',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _playSelected,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(42),
                              border: Border.all(
                                color: selected.color.withValues(alpha: 0.7),
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF082E59)
                                      .withValues(alpha: 0.2),
                                  blurRadius: 26,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                const Positioned(
                                  left: 24,
                                  top: 22,
                                  child: Text('⭐', style: TextStyle(fontSize: 34)),
                                ),
                                const Positioned(
                                  right: 26,
                                  bottom: 24,
                                  child: Text('☁️', style: TextStyle(fontSize: 54)),
                                ),
                                Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                      scale: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutBack,
                                      ),
                                      child: child,
                                    ),
                                    child: Text(
                                      selected.symbol,
                                      key: ValueKey(selected.audioFile),
                                      style: TextStyle(
                                        fontSize: widget.category ==
                                                ToddlerCategory.shapes
                                            ? 142
                                            : 156,
                                        color: widget.category ==
                                                ToddlerCategory.shapes
                                            ? selected.color
                                            : null,
                                        shadows: [
                                          Shadow(
                                            color: selected.color
                                                .withValues(alpha: 0.32),
                                            blurRadius: 18,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -42),
                        child: GestureDetector(
                          onTap: _playSelected,
                          child: Container(
                            width: 122,
                            height: 122,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF45C4FF), Color(0xFF0877E6)],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 7),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x66004F9F),
                                  blurRadius: 24,
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 68,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 132,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final selectedNow = index == _selectedIndex;
                            return GestureDetector(
                              onTap: () => _select(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 106,
                                decoration: BoxDecoration(
                                  color: item.color,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: selectedNow
                                        ? Colors.white
                                        : Colors.white70,
                                    width: selectedNow ? 6 : 3,
                                  ),
                                  boxShadow: selectedNow
                                      ? [
                                          BoxShadow(
                                            color: item.color
                                                .withValues(alpha: 0.48),
                                            blurRadius: 18,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    item.symbol,
                                    style: TextStyle(
                                      fontSize: 56,
                                      color: widget.category ==
                                              ToddlerCategory.shapes
                                          ? Colors.white
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _items.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: index == _selectedIndex ? 22 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: index == _selectedIndex
                                  ? KidPalette.sunshine
                                  : Colors.white70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 6,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 56,
          child: Icon(icon, color: Colors.white, size: 34),
        ),
      ),
    );
  }
}

class _ToddlerItem {
  const _ToddlerItem(this.symbol, this.audioFile, this.color);

  final String symbol;
  final String audioFile;
  final Color color;
}
