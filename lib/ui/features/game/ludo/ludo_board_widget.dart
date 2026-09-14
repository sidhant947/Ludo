import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../logic/ludo_game_controller.dart';
import '../../../../models/ludo_models.dart';
import '../../../../services/haptic_service.dart';
import '../../../core/theme/app_theme.dart';

class LudoBoardWidget extends StatefulWidget {
  const LudoBoardWidget({
    super.key,
    required this.controller,
    required this.colors,
  });

  final LudoGameController controller;
  final AppColors colors;

  @override
  State<LudoBoardWidget> createState() => _LudoBoardWidgetState();
}

class _LudoBoardWidgetState extends State<LudoBoardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleYardTap(LudoPlayer player) {
    if (widget.controller.currentPlayer == player &&
        widget.controller.currentPlayerType == LudoPlayerType.human &&
        widget.controller.canRoll &&
        !widget.controller.isRolling) {
      widget.controller.rollDice();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size;
        if (constraints.hasBoundedWidth && constraints.hasBoundedHeight) {
          size = math.min(constraints.maxWidth, constraints.maxHeight);
        } else if (constraints.hasBoundedWidth) {
          size = constraints.maxWidth;
        } else if (constraints.hasBoundedHeight) {
          size = constraints.maxHeight;
        } else {
          size = 360.0;
        }
        final cellSize = size / 15.0;
        final yardSize = 6 * cellSize;

        return _UnclippedHitTestBox(
          width: size,
          height: size,
          overflow: cellSize,
          child: _OverflowStack(
            clipBehavior: Clip.none,
            overflow: cellSize,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _LudoBoardPainter(
                    cellSize: cellSize,
                    activePlayers: widget.controller.activePlayers,
                    colors: widget.colors,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                width: yardSize,
                height: yardSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _handleYardTap(LudoPlayer.green),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                width: yardSize,
                height: yardSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _handleYardTap(LudoPlayer.yellow),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                width: yardSize,
                height: yardSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _handleYardTap(LudoPlayer.red),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                width: yardSize,
                height: yardSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => _handleYardTap(LudoPlayer.blue),
                ),
              ),
              ..._buildTokenWidgets(size, cellSize),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildTokenWidgets(double boardSize, double cellSize) {
    final tokens = widget.controller.allTokens;
    final movable = widget.controller.movableTokens;
    final isHuman = widget.controller.currentPlayerType == LudoPlayerType.human;

    final cellGroups = <String, List<LudoToken>>{};
    for (final token in tokens) {
      final pos = token.getPosition();
      final key = '${pos.$1.toStringAsFixed(1)}_${pos.$2.toStringAsFixed(1)}';
      cellGroups.putIfAbsent(key, () => []).add(token);
    }

    final widgets = <Widget>[];

    for (final entry in cellGroups.entries) {
      final group = entry.value;
      for (int i = 0; i < group.length; i++) {
        final token = group[i];
        final (x, y) = token.getPosition();
        final canMove = isHuman && movable.contains(token);

        double offsetX = 0;
        double offsetY = 0;

        if (group.length > 1 && !token.isAtYard && !token.isHome) {
          final shift = cellSize * 0.16;
          if (group.length == 2) {
            offsetX = i == 0 ? -shift : shift;
          } else if (group.length == 3) {
            offsetX = i == 0 ? -shift : (i == 1 ? shift : 0);
            offsetY = i == 2 ? shift : -shift * 0.5;
          } else {
            offsetX = (i % 2 == 0) ? -shift : shift;
            offsetY = (i < 2) ? -shift : shift;
          }
        }

        final tokenWidth = cellSize * 0.88;
        final tokenHeight = cellSize * 1.12;
        final left = x * cellSize + (cellSize - tokenWidth) / 2 + offsetX;
        final top = y * cellSize + (cellSize / 2) - tokenHeight + 1.5 + offsetY;

        widgets.add(
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            left: left,
            top: top,
            width: tokenWidth,
            height: tokenHeight,
            child: GestureDetector(
              onTap: canMove ? () {
                HapticService.light();
                widget.controller.moveToken(token);
              } : null,
              behavior: HitTestBehavior.opaque,
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  final scale = canMove ? 1.0 + (_animController.value * 0.12) : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: _TokenVisual(
                      token: token,
                      isMovable: canMove,
                      width: tokenWidth,
                      height: tokenHeight,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

class _TokenVisual extends StatelessWidget {
  const _TokenVisual({
    required this.token,
    required this.isMovable,
    required this.width,
    required this.height,
  });

  final LudoToken token;
  final bool isMovable;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final player = token.player;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _PinPainter(
          color: player.color,
          bevelColor: player.bevelColor,
          isMovable: isMovable,
        ),
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  _PinPainter({
    required this.color,
    required this.bevelColor,
    required this.isMovable,
  });

  final Color color;
  final Color bevelColor;
  final bool isMovable;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final r = w * 0.38;
    final cy = r + 2.0;
    final py = h - 1.5;

    Path createPinPath(double offsetY) {
      final p = Path();
      p.moveTo(cx, py + offsetY);
      p.cubicTo(
        cx - r * 0.35, py - (py - cy) * 0.35 + offsetY,
        cx - r, cy + r * 0.65 + offsetY,
        cx - r, cy + offsetY,
      );
      p.arcToPoint(
        Offset(cx + r, cy + offsetY),
        radius: Radius.circular(r),
        clockwise: true,
      );
      p.cubicTo(
        cx + r, cy + r * 0.65 + offsetY,
        cx + r * 0.35, py - (py - cy) * 0.35 + offsetY,
        cx, py + offsetY,
      );
      p.close();
      return p;
    }

    final shadowPath = createPinPath(2.5);
    final shadowPaint = Paint()..color = bevelColor;
    canvas.drawPath(shadowPath, shadowPaint);

    final pinPath = createPinPath(0);
    final pinPaint = Paint()..color = color;
    canvas.drawPath(pinPath, pinPaint);

    final borderPaint = Paint()
      ..color = isMovable ? Colors.white : Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isMovable ? 2.2 : 1.4;
    canvas.drawPath(pinPath, borderPaint);

    final innerR = r * 0.52;
    final innerPaint = Paint()..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawCircle(Offset(cx, cy), innerR, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.isMovable != isMovable;
  }
}

class _LudoBoardPainter extends CustomPainter {
  _LudoBoardPainter({
    required this.cellSize,
    required this.activePlayers,
    required this.colors,
  });

  final double cellSize;
  final List<LudoPlayer> activePlayers;
  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = colors.boardBed;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    _drawCornerYards(canvas);
    _drawTrackCells(canvas);
    _drawCenterGoal(canvas);
  }

  void _drawCornerYards(Canvas canvas) {
    _drawYard(canvas, 0, 0, LudoPlayer.green.color, LudoPlayer.green.bevelColor, LudoPlayer.green);
    _drawYard(canvas, 9, 0, LudoPlayer.yellow.color, LudoPlayer.yellow.bevelColor, LudoPlayer.yellow);
    _drawYard(canvas, 0, 9, LudoPlayer.red.color, LudoPlayer.red.bevelColor, LudoPlayer.red);
    _drawYard(canvas, 9, 9, LudoPlayer.blue.color, LudoPlayer.blue.bevelColor, LudoPlayer.blue);
  }

  void _drawYard(Canvas canvas, int col, int row, Color color, Color bevelColor, LudoPlayer player) {
    final left = col * cellSize;
    final top = row * cellSize;
    final yardWidth = 6 * cellSize;

    final isActive = activePlayers.contains(player);
    final displayColor = isActive ? color : colors.locked;
    final displayBevel = isActive ? bevelColor : colors.lockedBevel;

    final baseRect = Rect.fromLTWH(left, top, yardWidth, yardWidth);
    final yardPaint = Paint()..color = displayColor;
    canvas.drawRect(baseRect, yardPaint);

    final borderPaint = Paint()
      ..color = displayBevel
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(baseRect, borderPaint);

    final innerRect = Rect.fromLTWH(left + cellSize, top + cellSize, 4 * cellSize, 4 * cellSize);
    final innerPaint = Paint()..color = colors.card;
    canvas.drawRect(innerRect, innerPaint);

    final innerBorderPaint = Paint()
      ..color = colors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(innerRect, innerBorderPaint);

    for (final slot in player.yardCoords) {
      final cx = slot.$1 * cellSize + cellSize / 2;
      final cy = slot.$2 * cellSize + cellSize / 2;
      final slotRadius = cellSize * 0.38;

      final slotShadowPaint = Paint()..color = colors.bevel;
      canvas.drawCircle(Offset(cx, cy + 1), slotRadius, slotShadowPaint);

      final slotPaint = Paint()..color = displayColor.withValues(alpha: 0.35);
      canvas.drawCircle(Offset(cx, cy), slotRadius, slotPaint);

      final slotStroke = Paint()
        ..color = displayBevel.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(cx, cy), slotRadius, slotStroke);
    }
  }

  void _drawTrackCells(Canvas canvas) {
    final cellBorderPaint = Paint()
      ..color = colors.trackBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int r = 0; r < 15; r++) {
      for (int c = 0; c < 15; c++) {
        final inYard = (r < 6 && c < 6) || (r < 6 && c >= 9) || (r >= 9 && c < 6) || (r >= 9 && c >= 9);
        final inCenter = r >= 6 && r <= 8 && c >= 6 && c <= 8;

        if (inYard || inCenter) continue;

        final rect = Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize);

        Color fill = colors.trackCell;

        if (c == 7 && r >= 1 && r <= 5) fill = LudoPlayer.yellow.color;
        if (r == 7 && c >= 1 && c <= 5) fill = LudoPlayer.green.color;
        if (c == 7 && r >= 9 && r <= 13) fill = LudoPlayer.red.color;
        if (r == 7 && c >= 9 && c <= 13) fill = LudoPlayer.blue.color;

        if (c == 6 && r == 13) fill = LudoPlayer.red.color;
        if (c == 1 && r == 6) fill = LudoPlayer.green.color;
        if (c == 8 && r == 1) fill = LudoPlayer.yellow.color;
        if (c == 13 && r == 8) fill = LudoPlayer.blue.color;

        final fillPaint = Paint()..color = fill;
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, cellBorderPaint);

        final isSafe = (c == 6 && r == 13) ||
            (c == 1 && r == 6) ||
            (c == 8 && r == 1) ||
            (c == 13 && r == 8) ||
            (c == 2 && r == 8) ||
            (c == 6 && r == 2) ||
            (c == 12 && r == 6) ||
            (c == 8 && r == 12);

        if (isSafe) {
          _drawStar(canvas, c * cellSize + cellSize / 2, r * cellSize + cellSize / 2, cellSize * 0.26);
        }
      }
    }
  }

  void _drawStar(Canvas canvas, double cx, double cy, double radius) {
    final path = Path();
    final double innerRadius = radius * 0.45;
    for (int i = 0; i < 10; i++) {
      final double r = i.isEven ? radius : innerRadius;
      final double angle = (i * 36 - 90) * math.pi / 180.0;
      final double x = cx + r * math.cos(angle);
      final double y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final starPaint = Paint()..color = colors.starColor;
    canvas.drawPath(path, starPaint);
  }

  void _drawCenterGoal(Canvas canvas) {
    final cx = 7.5 * cellSize;
    final cy = 7.5 * cellSize;

    final left = 6 * cellSize;
    final top = 6 * cellSize;
    final right = 9 * cellSize;
    final bottom = 9 * cellSize;

    final greenPath = Path()
      ..moveTo(left, top)
      ..lineTo(cx, cy)
      ..lineTo(left, bottom)
      ..close();
    canvas.drawPath(greenPath, Paint()..color = LudoPlayer.green.color);

    final yellowPath = Path()
      ..moveTo(left, top)
      ..lineTo(cx, cy)
      ..lineTo(right, top)
      ..close();
    canvas.drawPath(yellowPath, Paint()..color = LudoPlayer.yellow.color);

    final skyPath = Path()
      ..moveTo(right, top)
      ..lineTo(cx, cy)
      ..lineTo(right, bottom)
      ..close();
    canvas.drawPath(skyPath, Paint()..color = LudoPlayer.blue.color);

    final peachPath = Path()
      ..moveTo(left, bottom)
      ..lineTo(cx, cy)
      ..lineTo(right, bottom)
      ..close();
    canvas.drawPath(peachPath, Paint()..color = LudoPlayer.red.color);

    final centerBorder = Paint()
      ..color = colors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), centerBorder);

    final goalPaint = Paint()..color = colors.card;
    canvas.drawCircle(Offset(cx, cy), cellSize * 0.55, goalPaint);
    canvas.drawCircle(Offset(cx, cy), cellSize * 0.55, centerBorder);

    _drawStar(canvas, cx, cy, cellSize * 0.38);
  }

  @override
  bool shouldRepaint(covariant _LudoBoardPainter oldDelegate) {
    return oldDelegate.cellSize != cellSize ||
        oldDelegate.activePlayers != activePlayers ||
        oldDelegate.colors != colors;
  }
}

class _UnclippedHitTestBox extends SingleChildRenderObjectWidget {
  const _UnclippedHitTestBox({
    required this.width,
    required this.height,
    required this.overflow,
    required Widget super.child,
  });

  final double width;
  final double height;
  final double overflow;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderUnclippedBox(width: width, height: height, overflow: overflow);

  @override
  void updateRenderObject(BuildContext context, _RenderUnclippedBox renderObject) {
    renderObject
      ..width = width
      ..height = height
      ..overflow = overflow;
  }
}

class _RenderUnclippedBox extends RenderProxyBox {
  _RenderUnclippedBox({
    required this._width,
    required this._height,
    required this.overflow,
  });

  double _width;
  set width(double value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  double _height;
  set height(double value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  double overflow;

  @override
  void performLayout() {
    size = constraints.constrain(Size(_width, _height));
    if (child != null) {
      child!.layout(BoxConstraints.tight(size), parentUsesSize: true);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final Rect expanded = (Offset.zero & size).inflate(overflow);
    if (expanded.contains(position)) {
      if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }
}

class _OverflowStack extends Stack {
  const _OverflowStack({
    super.clipBehavior = Clip.none,
    required this.overflow,
    super.children,
  });

  final double overflow;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderOverflowStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      fit: fit,
      clipBehavior: clipBehavior,
      overflow: overflow,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderOverflowStack renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.overflow = overflow;
  }
}

class _RenderOverflowStack extends RenderStack {
  _RenderOverflowStack({
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior,
    required this.overflow,
  });

  double overflow;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final Rect expanded = (Offset.zero & size).inflate(overflow);
    if (expanded.contains(position)) {
      if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }
}
