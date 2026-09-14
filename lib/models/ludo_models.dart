import 'package:flutter/material.dart';

enum LudoPlayerType { human, bot }

enum LudoPlayer {
  red(
    name: 'Red',
    color: Color(0xFFFF4B4B),
    bevelColor: Color(0xFFD43535),
    textColor: Colors.white,
    startIndex: 0,
    yardCoords: [(1.5, 10.5), (3.5, 10.5), (1.5, 12.5), (3.5, 12.5)],
    homeCoords: [(7, 13), (7, 12), (7, 11), (7, 10), (7, 9)],
    centerCoord: (7.0, 7.8),
  ),
  green(
    name: 'Green',
    color: Color(0xFF009900),
    bevelColor: Color(0xFF007700),
    textColor: Colors.white,
    startIndex: 13,
    yardCoords: [(1.5, 1.5), (3.5, 1.5), (1.5, 3.5), (3.5, 3.5)],
    homeCoords: [(1, 7), (2, 7), (3, 7), (4, 7), (5, 7)],
    centerCoord: (6.2, 7.0),
  ),
  yellow(
    name: 'Yellow',
    color: Color(0xFFFFCC00),
    bevelColor: Color(0xFFD9AD00),
    textColor: Color(0xFF4A3B00),
    startIndex: 26,
    yardCoords: [(10.5, 1.5), (12.5, 1.5), (10.5, 3.5), (12.5, 3.5)],
    homeCoords: [(7, 1), (7, 2), (7, 3), (7, 4), (7, 5)],
    centerCoord: (7.0, 6.2),
  ),
  blue(
    name: 'Blue',
    color: Color(0xFF0066FF),
    bevelColor: Color(0xFF0052CC),
    textColor: Colors.white,
    startIndex: 39,
    yardCoords: [(10.5, 10.5), (12.5, 10.5), (10.5, 12.5), (12.5, 12.5)],
    homeCoords: [(13, 7), (12, 7), (11, 7), (10, 7), (9, 7)],
    centerCoord: (7.8, 7.0),
  );

  const LudoPlayer({
    required this.name,
    required this.color,
    required this.bevelColor,
    required this.textColor,
    required this.startIndex,
    required this.yardCoords,
    required this.homeCoords,
    required this.centerCoord,
  });

  final String name;
  final Color color;
  final Color bevelColor;
  final Color textColor;
  final int startIndex;
  final List<(double, double)> yardCoords;
  final List<(int, int)> homeCoords;
  final (double, double) centerCoord;
}

class LudoTrack {
  static const List<(int, int)> outerPath = [
    (6, 13), (6, 12), (6, 11), (6, 10), (6, 9),
    (5, 8), (4, 8), (3, 8), (2, 8), (1, 8), (0, 8),
    (0, 7),
    (0, 6), (1, 6), (2, 6), (3, 6), (4, 6), (5, 6),
    (6, 5), (6, 4), (6, 3), (6, 2), (6, 1), (6, 0),
    (7, 0),
    (8, 0), (8, 1), (8, 2), (8, 3), (8, 4), (8, 5),
    (9, 6), (10, 6), (11, 6), (12, 6), (13, 6), (14, 6),
    (14, 7),
    (14, 8), (13, 8), (12, 8), (11, 8), (10, 8), (9, 8),
    (8, 9), (8, 10), (8, 11), (8, 12), (8, 13), (8, 14),
    (7, 14),
    (6, 14),
  ];

  static const Set<int> safeIndices = {0, 8, 13, 21, 26, 34, 39, 47};

  static bool isSafe(int index) => safeIndices.contains(index);
}

class LudoToken {
  LudoToken({
    required this.id,
    required this.player,
    this.step = -1,
  });

  final int id;
  final LudoPlayer player;
  int step;

  bool get isAtYard => step == -1;
  bool get isHome => step == 56;
  bool get isOnTrack => step >= 0 && step <= 50;
  bool get isInHomeRun => step >= 51 && step <= 55;

  int get trackIndex => (player.startIndex + step) % 52;

  (double, double) getPosition() {
    if (step == -1) {
      return player.yardCoords[id];
    }
    if (step <= 50) {
      final coord = LudoTrack.outerPath[trackIndex];
      return (coord.$1.toDouble(), coord.$2.toDouble());
    }
    if (step <= 55) {
      final coord = player.homeCoords[step - 51];
      return (coord.$1.toDouble(), coord.$2.toDouble());
    }
    final (cx, cy) = player.centerCoord;
    final offset = switch (id) {
      0 => (-0.15, -0.15),
      1 => (0.15, -0.15),
      2 => (-0.15, 0.15),
      _ => (0.15, 0.15),
    };
    return (cx + offset.$1, cy + offset.$2);
  }
}
