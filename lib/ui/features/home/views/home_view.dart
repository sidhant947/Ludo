import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
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
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _GameSetupDialog(
          humanCount: _humanCount,
          botCount: _botCount,
          onStartMatch: (activePlayers, playerTypes, playerNames) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LudoGameScreen(
                  humanCount: _humanCount,
                  botCount: _botCount,
                  activePlayers: activePlayers,
                  playerTypes: playerTypes,
                  playerNames: playerNames,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

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
                          l10n.appTitle,
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
                              l10n.humans,
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
                              l10n.bots,
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
                          l10n.play,
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
                          l10n.settings,
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

class _GameSetupDialog extends StatefulWidget {
  const _GameSetupDialog({
    required this.humanCount,
    required this.botCount,
    required this.onStartMatch,
  });

  final int humanCount;
  final int botCount;
  final void Function(
    List<LudoPlayer> activePlayers,
    Map<LudoPlayer, LudoPlayerType> playerTypes,
    Map<LudoPlayer, String> playerNames,
  ) onStartMatch;

  @override
  State<_GameSetupDialog> createState() => _GameSetupDialogState();
}

class _GameSetupDialogState extends State<_GameSetupDialog> {
  static const _twoPlayerSets = [
    [LudoPlayer.red, LudoPlayer.yellow],
    [LudoPlayer.green, LudoPlayer.blue],
  ];

  static const _threePlayerSets = [
    [LudoPlayer.green, LudoPlayer.red, LudoPlayer.yellow],
    [LudoPlayer.red, LudoPlayer.yellow, LudoPlayer.blue],
    [LudoPlayer.green, LudoPlayer.red, LudoPlayer.blue],
    [LudoPlayer.green, LudoPlayer.yellow, LudoPlayer.blue],
  ];

  static const _fourPlayerSets = [
    [LudoPlayer.red, LudoPlayer.green, LudoPlayer.yellow, LudoPlayer.blue],
  ];

  int _selectedSetIndex = 0;
  late List<LudoPlayer> _playerColors;
  late List<TextEditingController> _nameControllers;

  List<List<LudoPlayer>> get _currentSets {
    final total = widget.humanCount + widget.botCount;
    if (total == 2) return _twoPlayerSets;
    if (total == 3) return _threePlayerSets;
    return _fourPlayerSets;
  }

  @override
  void initState() {
    super.initState();
    final total = widget.humanCount + widget.botCount;
    _playerColors = List.from(_currentSets[_selectedSetIndex]);
    _nameControllers = List.generate(total, (i) {
      final isBot = i >= widget.humanCount;
      final defaultName = isBot
          ? (widget.botCount == 1 ? 'Bot' : 'Bot ${i - widget.humanCount + 1}')
          : (widget.humanCount == 1 ? 'Player' : 'Player ${i + 1}');
      return TextEditingController(text: defaultName);
    });
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onStart() {
    final total = widget.humanCount + widget.botCount;
    const clockwise = [LudoPlayer.red, LudoPlayer.green, LudoPlayer.yellow, LudoPlayer.blue];
    final activeSet = _playerColors.toSet();
    final p1Index = clockwise.indexOf(_playerColors[0]);
    final ordered = <LudoPlayer>[];
    for (int step = 0; step < 4; step++) {
      final candidate = clockwise[(p1Index + step) % 4];
      if (activeSet.contains(candidate)) {
        ordered.add(candidate);
      }
    }

    final playerTypes = <LudoPlayer, LudoPlayerType>{};
    final playerNames = <LudoPlayer, String>{};

    for (int i = 0; i < total; i++) {
      final color = _playerColors[i];
      playerTypes[color] = i < widget.humanCount ? LudoPlayerType.human : LudoPlayerType.bot;
      final text = _nameControllers[i].text.trim();
      if (text.isNotEmpty) {
        playerNames[color] = text;
      }
    }

    Navigator.pop(context);
    widget.onStartMatch(ordered, playerTypes, playerNames);
  }

  Widget _buildSetButton(int idx, List<LudoPlayer> set, AppColors colors) {
    final isSelected = _selectedSetIndex == idx;
    return TangibleButton(
      height: 42,
      padding: EdgeInsets.zero,
      color: isSelected ? colors.mint : colors.canvas,
      bevelColor: isSelected ? colors.mintBevel : colors.bevel,
      elevation: isSelected ? 4 : 2,
      onPressed: () {
        setState(() {
          _selectedSetIndex = idx;
          _playerColors = List.from(_currentSets[idx]);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: set.map((p) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: p.color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final total = widget.humanCount + widget.botCount;
    final activeSet = _currentSets[_selectedSetIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: TangibleCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.gameSetup,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: colors.text,
                    ),
                  ),
                  TangibleIconButton(
                    icon: Icons.close_rounded,
                    size: 36,
                    elevation: 2,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.colors,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              if (total == 2)
                Row(
                  children: [0, 1].map((idx) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: idx == 1 ? 6 : 0, right: idx == 0 ? 6 : 0),
                        child: _buildSetButton(idx, _twoPlayerSets[idx], colors),
                      ),
                    );
                  }).toList(),
                )
              else if (total == 3)
                Column(
                  children: [
                    Row(
                      children: [0, 1].map((idx) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: idx == 1 ? 6 : 0, right: idx == 0 ? 6 : 0),
                            child: _buildSetButton(idx, _threePlayerSets[idx], colors),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [2, 3].map((idx) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: idx == 3 ? 6 : 0, right: idx == 2 ? 6 : 0),
                            child: _buildSetButton(idx, _threePlayerSets[idx], colors),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              else
                _buildSetButton(0, _fourPlayerSets[0], colors),
              const SizedBox(height: 16),
              Text(
                l10n.players,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(total, (i) {
                final isBot = i >= widget.humanCount;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                        isBot ? Icons.smart_toy_rounded : Icons.person_rounded,
                        size: 20,
                        color: isBot ? colors.textMuted : colors.mintText,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _nameControllers[i],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            filled: true,
                            fillColor: colors.canvas,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: colors.border, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: colors.border, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: colors.mint, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: activeSet.map((color) {
                          final isSelected = _playerColors[i] == color;
                          return GestureDetector(
                            onTap: () {
                              if (!isSelected) {
                                final other = _playerColors.indexOf(color);
                                setState(() {
                                  final old = _playerColors[i];
                                  _playerColors[i] = color;
                                  if (other != -1) _playerColors[other] = old;
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: color.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.bevelColor.withValues(alpha: 0.6),
                                          offset: const Offset(0, 1.5),
                                          blurRadius: 3,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              TangibleButton(
                height: 50,
                color: colors.mint,
                bevelColor: colors.mintBevel,
                onPressed: _onStart,
                child: Text(
                  l10n.startGame,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: colors.mintText,
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
