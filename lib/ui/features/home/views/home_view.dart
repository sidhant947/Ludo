import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/ludo_models.dart';
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
  int _selectedCount = 4;
  bool _vsBot = true;

  static const _playerColorsByCount = <int, List<LudoPlayer>>{
    2: [LudoPlayer.red, LudoPlayer.yellow],
    3: [LudoPlayer.red, LudoPlayer.green, LudoPlayer.yellow],
    4: [LudoPlayer.red, LudoPlayer.green, LudoPlayer.yellow, LudoPlayer.blue],
  };

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
          playerCount: _selectedCount,
          vsBot: _vsBot,
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
                              'PLAYERS',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: colors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [2, 3, 4].map((count) {
                                final isSelected = _selectedCount == count;
                                final players = _playerColorsByCount[count]!;

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: TangibleButton(
                                      height: 66,
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      color: isSelected ? colors.mint : colors.canvas,
                                      bevelColor: isSelected ? colors.mintBevel : colors.bevel,
                                      elevation: isSelected ? 4 : 2,
                                      onPressed: () {
                                        setState(() {
                                          _selectedCount = count;
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${count}P',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                              color: isSelected ? colors.mintText : colors.text,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: players.map((p) {
                                              return Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                  color: p.color,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: isSelected ? Colors.white.withValues(alpha: 0.8) : colors.border,
                                                    width: 1,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
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
                              'GAME MODE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: colors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TangibleButton(
                                    height: 66,
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    color: !_vsBot ? colors.mint : colors.canvas,
                                    bevelColor: !_vsBot ? colors.mintBevel : colors.bevel,
                                    elevation: !_vsBot ? 4 : 2,
                                    onPressed: () {
                                      setState(() {
                                        _vsBot = false;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.people_alt_rounded,
                                          size: 22,
                                          color: !_vsBot ? colors.mintText : colors.text,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Pass & Play',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: !_vsBot ? colors.mintText : colors.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TangibleButton(
                                    height: 66,
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    color: _vsBot ? colors.mint : colors.canvas,
                                    bevelColor: _vsBot ? colors.mintBevel : colors.bevel,
                                    elevation: _vsBot ? 4 : 2,
                                    onPressed: () {
                                      setState(() {
                                        _vsBot = true;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.smart_toy_rounded,
                                          size: 22,
                                          color: _vsBot ? colors.mintText : colors.text,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'With Bots',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: _vsBot ? colors.mintText : colors.text,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
