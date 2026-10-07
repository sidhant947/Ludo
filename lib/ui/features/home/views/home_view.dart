import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tangible_widgets.dart';
import '../../game/ludo/ludo_game_screen.dart';
import '../../settings/views/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _humanCount = 1;
  int _botCount = 3;

  void _setHumanCount(int count) {
    setState(() {
      _humanCount = count;
      _botCount = _botCount.clamp(math.max(0, 2 - count), 4 - count);
    });
  }

  void _setBotCount(int count) {
    setState(() {
      _botCount = count;
      _humanCount = _humanCount.clamp(math.max(1, 2 - count), 4 - count);
    });
  }

  Future<void> _openUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri);
    }
  }

  void _startMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LudoGameScreen(
          humanCount: _humanCount,
          botCount: _botCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: TangibleIconButton(
              icon: Icons.star_rounded,
              iconColor: Colors.amber,
              onPressed: () => _openUrl('https://github.com/sidhant947/Ludo'),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: TangibleIconButton(
                icon: Icons.favorite_rounded,
                iconColor: Colors.red,
                onPressed: () => _openUrl('https://ko-fi.com/sidhant947'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Center(
                        child: Text(
                          'Ludo',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                            color: colors.text,
                            letterSpacing: -1.0,
                            shadows: [
                              Shadow(
                                color: colors.bevel,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      TangibleCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'HUMANS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: colors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [1, 2, 3, 4].map((count) {
                                final isSelected = _humanCount == count;

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    child: TangibleButton(
                                      height: 58,
                                      padding: EdgeInsets.zero,
                                      color: isSelected ? colors.mint : colors.canvas,
                                      bevelColor: isSelected ? colors.mintBevel : colors.bevel,
                                      elevation: isSelected ? 4 : 2,
                                      onPressed: () => _setHumanCount(count),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person_rounded,
                                            size: 16,
                                            color: isSelected ? colors.mintText : colors.textMuted,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$count',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: isSelected ? colors.mintText : colors.text,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'BOTS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: colors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [0, 1, 2, 3].map((count) {
                                final isSelected = _botCount == count;

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    child: TangibleButton(
                                      height: 58,
                                      padding: EdgeInsets.zero,
                                      color: isSelected ? colors.mint : colors.canvas,
                                      bevelColor: isSelected ? colors.mintBevel : colors.bevel,
                                      elevation: isSelected ? 4 : 2,
                                      onPressed: () => _setBotCount(count),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.smart_toy_rounded,
                                            size: 16,
                                            color: isSelected ? colors.mintText : colors.textMuted,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$count',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: isSelected ? colors.mintText : colors.text,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TangibleButton(
                        height: 56,
                        color: colors.mint,
                        bevelColor: colors.mintBevel,
                        onPressed: _startMatch,
                        child: Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: colors.mintText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TangibleButton(
                        height: 52,
                        color: colors.sky,
                        bevelColor: colors.skyBevel,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SettingsView()),
                          );
                        },
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: colors.skyText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
