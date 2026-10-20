import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../logic/ludo_game_controller.dart';
import '../../../../models/ludo_models.dart';
import '../../../../services/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tangible_widgets.dart';
import 'ludo_board_widget.dart';

class LudoGameScreen extends StatefulWidget {
  const LudoGameScreen({
    super.key,
    this.playerCount,
    this.vsBot,
    this.humanCount,
    this.botCount,
    this.controller,
  });

  final int? playerCount;
  final bool? vsBot;
  final int? humanCount;
  final int? botCount;
  final LudoGameController? controller;

  @override
  State<LudoGameScreen> createState() => _LudoGameScreenState();
}

class _LudoGameScreenState extends State<LudoGameScreen> with SingleTickerProviderStateMixin {
  late LudoGameController _controller;
  late AnimationController _pulseController;
  bool _winDialogShown = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _controller = widget.controller ?? LudoGameController(
      humanCount: widget.humanCount,
      botCount: widget.botCount,
      playerCount: widget.playerCount,
      vsBot: widget.vsBot,
    );
    _controller.addListener(_onControllerUpdate);
    AudioService.setGameplay(true);
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() {});

    if (_controller.isGameOver && !_winDialogShown) {
      _winDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinnerDialog();
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.removeListener(_onControllerUpdate);
    if (widget.controller == null) {
      _controller.dispose();
    }
    AudioService.setGameplay(false);
    super.dispose();
  }

  void _showWinnerDialog() {
    final winner = _controller.winner ?? _controller.activePlayers.first;
    final rankings = _controller.rankings;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final colors = dialogContext.colors;

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: SingleChildScrollView(
            child: TangibleCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: winner.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: winner.bevelColor.withValues(alpha: 0.5),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.emoji_events_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${winner.name} Takes #1!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Match Standings',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(rankings.length, (index) {
                    final player = rankings[index];
                    final isLoss = index == rankings.length - 1;
                    final rankText = isLoss ? 'Loss' : '#${index + 1}';
                    final isBot = _controller.playerTypes[player] == LudoPlayerType.bot;

                    final Color badgeBg;
                    final Color badgeText;
                    final Color badgeBorder;
                    if (index == 0) {
                      badgeBg = colors.butter;
                      badgeText = colors.butterText;
                      badgeBorder = colors.butterBevel;
                    } else if (isLoss) {
                      badgeBg = colors.peach.withValues(alpha: 0.15);
                      badgeText = colors.peachText;
                      badgeBorder = colors.peach;
                    } else {
                      badgeBg = colors.card;
                      badgeText = colors.text;
                      badgeBorder = colors.border;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: index == 0 ? winner.color.withValues(alpha: 0.45) : colors.border,
                          width: index == 0 ? 2 : 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            constraints: const BoxConstraints(minWidth: 46),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: badgeBorder, width: 1.5),
                            ),
                            child: Text(
                              rankText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: badgeText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: player.color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: player.bevelColor.withValues(alpha: 0.4),
                                  offset: const Offset(0, 1.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${player.name}${isBot ? ' (Bot)' : ''}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colors.text,
                              ),
                            ),
                          ),
                          if (index == 0)
                            Icon(
                              Icons.military_tech_rounded,
                              color: colors.butter,
                              size: 22,
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 14),
                  TangibleButton(
                    height: 48,
                    color: winner.color,
                    bevelColor: winner.bevelColor,
                    elevation: 3,
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _winDialogShown = false;
                      _controller.resetGame();
                    },
                    child: Text(
                      'Play Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: winner.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TangibleButton(
                    height: 48,
                    color: colors.card,
                    bevelColor: colors.bevel,
                    elevation: 3,
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final colors = dialogContext.colors;

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: TangibleCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Leave Game?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: colors.text,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current match progress will be lost.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TangibleButton(
                        height: 46,
                        color: colors.card,
                        bevelColor: colors.bevel,
                        elevation: 3,
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Stay',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TangibleButton(
                        height: 46,
                        color: colors.peach,
                        bevelColor: colors.peachBevel,
                        elevation: 3,
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Leave',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: colors.peachText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Center(
              child: TangibleIconButton(
                icon: Icons.arrow_back_rounded,
                onPressed: _confirmExit,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;

              final boardSize = math.min(maxWidth - 32, maxHeight - 160).clamp(240.0, 520.0);
              final yardWidth = (boardSize / 15.0) * 6;
              final middleWidth = (boardSize / 15.0) * 3;

              return Center(
                child: SizedBox(
                  width: boardSize,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          _buildYardAttachedDice(LudoPlayer.green, yardWidth, colors),
                          SizedBox(width: middleWidth),
                          _buildYardAttachedDice(LudoPlayer.yellow, yardWidth, colors),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LudoBoardWidget(controller: _controller, colors: colors),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildYardAttachedDice(LudoPlayer.red, yardWidth, colors),
                          SizedBox(width: middleWidth),
                          _buildYardAttachedDice(LudoPlayer.blue, yardWidth, colors),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildYardAttachedDice(LudoPlayer player, double width, AppColors colors) {
    final isActive = _controller.activePlayers.contains(player);
    if (!isActive) {
      return SizedBox(width: width, height: 50);
    }

    final hasFinished = _controller.hasPlayerFinished(player);
    final rankIdx = _controller.rankings.indexOf(player);
    if (hasFinished && rankIdx != -1 && rankIdx < _controller.rankings.length - 1) {
      return SizedBox(
        width: width,
        height: 50,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: player.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: player.color, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_rounded, size: 16, color: player.color),
                const SizedBox(width: 4),
                Text(
                  '#${rankIdx + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: colors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isCurrent = _controller.currentPlayer == player;
    final isHuman = _controller.playerTypes[player] == LudoPlayerType.human;
    final isBot = _controller.playerTypes[player] == LudoPlayerType.bot;
    final canRoll = isCurrent &&
        _controller.canRoll &&
        !_controller.isRolling &&
        !_controller.isMoving &&
        isHuman &&
        !_controller.isGameOver;
    final isRollingNow = isCurrent && _controller.isRolling;
    final diceVal = _controller.getDiceFor(player);

    final diceButton = _DiceButton(
      player: player,
      value: diceVal,
      isCurrent: isCurrent,
      canRoll: canRoll,
      isRolling: isRollingNow,
      colors: colors,
      pulseAnimation: _pulseController,
      onTap: canRoll ? () => _controller.rollDice() : null,
    );

    return SizedBox(
      width: width,
      height: 50,
      child: Center(
        child: isBot
            ? Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  diceButton,
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: colors.card,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border, width: 1.5),
                      ),
                      child: Icon(
                        Icons.smart_toy_rounded,
                        size: 11,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              )
            : diceButton,
      ),
    );
  }

}

class _DiceButton extends StatefulWidget {
  const _DiceButton({
    required this.player,
    required this.value,
    required this.isCurrent,
    required this.canRoll,
    required this.isRolling,
    required this.colors,
    required this.pulseAnimation,
    required this.onTap,
  });

  final LudoPlayer player;
  final int value;
  final bool isCurrent;
  final bool canRoll;
  final bool isRolling;
  final AppColors colors;
  final Animation<double> pulseAnimation;
  final VoidCallback? onTap;

  @override
  State<_DiceButton> createState() => _DiceButtonState();
}

class _DiceButtonState extends State<_DiceButton> with TickerProviderStateMixin {
  late AnimationController _tumbleController;
  late AnimationController _settleController;

  @override
  void initState() {
    super.initState();
    _tumbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    );
    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    if (widget.isRolling) {
      _tumbleController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _DiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isRolling && widget.isRolling) {
      _settleController.reset();
      _tumbleController.repeat(reverse: true);
    } else if (oldWidget.isRolling && !widget.isRolling) {
      _tumbleController.stop();
      _tumbleController.reset();
      _settleController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _tumbleController.dispose();
    _settleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final isCurrent = widget.isCurrent;
    final player = widget.player;

    final diceWidget = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isCurrent ? player.bevelColor : colors.diceInactiveBevel,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isCurrent ? player.bevelColor.withValues(alpha: 0.4) : colors.bevel.withValues(alpha: 0.5),
            offset: const Offset(0, 3),
            blurRadius: isCurrent ? 5 : 2,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          color: isCurrent ? player.color : colors.diceInactive,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent ? Colors.white : colors.border,
            width: 1.5,
          ),
        ),
        child: Center(
          child: _DiceFace(
            value: widget.value,
            dotColor: isCurrent ? player.textColor : colors.diceInactiveDot,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          widget.pulseAnimation,
          _tumbleController,
          _settleController,
        ]),
        builder: (context, child) {
          double scale = 1.0;
          double rotation = 0.0;
          double offsetY = 0.0;

          if (widget.isRolling) {
            final t = _tumbleController.value;
            scale = 1.12 + (t * 0.08);
            rotation = (t - 0.5) * 0.35;
            offsetY = -5.0 * t;
          } else if (_settleController.isAnimating) {
            final settleCurve = Curves.easeOutBack.transform(_settleController.value);
            scale = 1.0 + ((1.0 - settleCurve) * 0.22);
          } else if (widget.canRoll) {
            scale = 1.0 + (widget.pulseAnimation.value * 0.12);
          }

          return Transform.translate(
            offset: Offset(0, offsetY),
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: diceWidget,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DiceFace extends StatelessWidget {
  const _DiceFace({
    required this.value,
    required this.dotColor,
  });

  final int value;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: CustomPaint(
        painter: _DicePainter(value: value, dotColor: dotColor),
      ),
    );
  }
}

class _DicePainter extends CustomPainter {
  _DicePainter({required this.value, required this.dotColor});

  final int value;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    final r = size.width * 0.10;
    final w = size.width;
    final h = size.height;

    final left = w * 0.25;
    final center = w * 0.5;
    final right = w * 0.75;

    final top = h * 0.25;
    final middle = h * 0.5;
    final bottom = h * 0.75;

    switch (value) {
      case 1:
        canvas.drawCircle(Offset(center, middle), r * 1.35, paint);
        break;
      case 2:
        canvas.drawCircle(Offset(left, top), r, paint);
        canvas.drawCircle(Offset(right, bottom), r, paint);
        break;
      case 3:
        canvas.drawCircle(Offset(left, top), r, paint);
        canvas.drawCircle(Offset(center, middle), r, paint);
        canvas.drawCircle(Offset(right, bottom), r, paint);
        break;
      case 4:
        canvas.drawCircle(Offset(left, top), r, paint);
        canvas.drawCircle(Offset(right, top), r, paint);
        canvas.drawCircle(Offset(left, bottom), r, paint);
        canvas.drawCircle(Offset(right, bottom), r, paint);
        break;
      case 5:
        canvas.drawCircle(Offset(left, top), r, paint);
        canvas.drawCircle(Offset(right, top), r, paint);
        canvas.drawCircle(Offset(center, middle), r, paint);
        canvas.drawCircle(Offset(left, bottom), r, paint);
        canvas.drawCircle(Offset(right, bottom), r, paint);
        break;
      case 6:
        canvas.drawCircle(Offset(left, top), r, paint);
        canvas.drawCircle(Offset(right, top), r, paint);
        canvas.drawCircle(Offset(left, middle), r, paint);
        canvas.drawCircle(Offset(right, middle), r, paint);
        canvas.drawCircle(Offset(left, bottom), r, paint);
        canvas.drawCircle(Offset(right, bottom), r, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _DicePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.dotColor != dotColor;
  }
}
