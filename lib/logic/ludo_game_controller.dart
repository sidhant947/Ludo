import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/ludo_models.dart';
import '../services/haptic_service.dart';

class LudoGameController extends ChangeNotifier {
  LudoGameController({
    int? humanCount,
    int? botCount,
    int? playerCount,
    bool? vsBot,
  }) {
    final humans = humanCount ?? (vsBot == true ? 1 : (playerCount ?? 4));
    final bots = botCount ?? (vsBot == true ? (playerCount ?? 4) - 1 : 0);
    _initGame(humans, bots);
  }

  late int humanCount;
  late int botCount;
  final Random _random = Random();
  late List<LudoPlayer> activePlayers;
  late Map<LudoPlayer, LudoPlayerType> playerTypes;
  late List<LudoToken> allTokens;
  late Map<LudoPlayer, int> playerDice;

  int _currentPlayerIndex = 0;
  int? _currentDice;
  bool _isRolling = false;
  bool _canRoll = true;
  List<LudoToken> _movableTokens = [];
  int _consecutiveSixes = 0;
  LudoPlayer? _winner;
  bool _isGameOver = false;
  List<LudoPlayer> _finishedRankings = [];
  bool _isDisposed = false;

  LudoPlayer get currentPlayer => activePlayers[_currentPlayerIndex];
  LudoPlayerType get currentPlayerType => playerTypes[currentPlayer]!;
  int? get currentDice => _currentDice;
  bool get isRolling => _isRolling;
  bool get canRoll => _canRoll;
  List<LudoToken> get movableTokens => _movableTokens;
  LudoPlayer? get winner => _winner;
  bool get isGameOver => _isGameOver;
  List<LudoPlayer> get rankings => List.unmodifiable(_finishedRankings);
  bool hasPlayerFinished(LudoPlayer player) => _finishedRankings.contains(player);

  int getDiceFor(LudoPlayer player) => playerDice[player] ?? 1;

  void _initGame(int humans, int bots) {
    humanCount = humans;
    botCount = bots;
    final count = (humans + bots).clamp(2, 4);
    if (count == 2) {
      activePlayers = [LudoPlayer.red, LudoPlayer.yellow];
    } else if (count == 3) {
      activePlayers = [LudoPlayer.red, LudoPlayer.green, LudoPlayer.yellow];
    } else {
      activePlayers = [LudoPlayer.red, LudoPlayer.green, LudoPlayer.yellow, LudoPlayer.blue];
    }

    playerTypes = {};
    for (int i = 0; i < activePlayers.length; i++) {
      final p = activePlayers[i];
      playerTypes[p] = i < humans ? LudoPlayerType.human : LudoPlayerType.bot;
    }

    allTokens = [];
    for (final p in activePlayers) {
      for (int id = 0; id < 4; id++) {
        allTokens.add(LudoToken(id: id, player: p));
      }
    }

    playerDice = {for (final p in activePlayers) p: 1};

    _currentPlayerIndex = 0;
    _currentDice = null;
    _isRolling = false;
    _canRoll = true;
    _movableTokens = [];
    _consecutiveSixes = 0;
    _winner = null;
    _isGameOver = false;
    _finishedRankings = [];

    _checkBotTurn();
  }

  void resetGame({int? humanCount, int? botCount, int? playerCount, bool? vsBot}) {
    final humans = humanCount ?? (vsBot != null ? (vsBot ? 1 : (playerCount ?? this.humanCount)) : this.humanCount);
    final bots = botCount ?? (vsBot != null ? (vsBot ? (playerCount ?? (this.humanCount + this.botCount)) - 1 : 0) : this.botCount);
    _initGame(humans, bots);
    notifyListeners();
  }

  List<LudoToken> getTokensFor(LudoPlayer player) {
    return allTokens.where((t) => t.player == player).toList();
  }

  Future<void> rollDice() async {
    if (!_canRoll || _isRolling || _isGameOver) return;
    if (_finishedRankings.contains(currentPlayer)) return;

    _isRolling = true;
    _movableTokens = [];
    notifyListeners();
    HapticService.selection();

    for (int i = 0; i < 6; i++) {
      if (_isDisposed) return;
      _currentDice = _random.nextInt(6) + 1;
      playerDice[currentPlayer] = _currentDice!;
      notifyListeners();
      HapticService.selection();
      await Future.delayed(const Duration(milliseconds: 65));
    }

    _currentDice = _random.nextInt(6) + 1;
    playerDice[currentPlayer] = _currentDice!;
    _isRolling = false;
    _canRoll = false;
    if (_currentDice == 6) {
      HapticService.heavy();
    } else {
      HapticService.medium();
    }

    if (_currentDice == 6) {
      _consecutiveSixes++;
      if (_consecutiveSixes >= 3) {
        _consecutiveSixes = 0;
        _passTurn();
        return;
      }
    } else {
      _consecutiveSixes = 0;
    }

    _movableTokens = _computeMovableTokens(currentPlayer, _currentDice!);
    notifyListeners();

    if (_movableTokens.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!_isDisposed) {
        _passTurn();
      }
    } else if (currentPlayerType == LudoPlayerType.bot) {
      await Future.delayed(const Duration(milliseconds: 550));
      if (!_isDisposed) {
        _handleBotMove();
      }
    } else if (_movableTokens.length == 1) {
      await Future.delayed(const Duration(milliseconds: 380));
      if (!_isDisposed && _movableTokens.length == 1) {
        moveToken(_movableTokens.first);
      }
    }
  }

  List<LudoToken> _computeMovableTokens(LudoPlayer player, int dice) {
    final tokens = getTokensFor(player);
    final valid = <LudoToken>[];

    bool addedYardToken = false;
    for (final token in tokens) {
      if (token.isAtYard) {
        if (dice == 6 && !addedYardToken) {
          valid.add(token);
          addedYardToken = true;
        }
      } else if (!token.isHome) {
        if (token.step + dice <= 56) {
          valid.add(token);
        }
      }
    }

    return valid;
  }

  Future<void> moveToken(LudoToken token) async {
    if (_movableTokens.isEmpty || !_movableTokens.contains(token) || _isRolling || _isGameOver) {
      return;
    }

    _movableTokens = [];
    final dice = _currentDice!;
    bool bonusTurn = false;

    if (token.isAtYard) {
      token.step = 0;
      bonusTurn = true;
      HapticService.medium();
    } else {
      token.step += dice;
      HapticService.light();
      if (token.step == 56) {
        if (_hasPlayerWon(token.player)) {
          HapticService.vibrate();
          _recordPlayerFinished(token.player);
          if (_isGameOver) {
            notifyListeners();
            return;
          }
          _passTurn();
          return;
        }
        HapticService.medium();
        bonusTurn = true;
      } else if (token.step <= 50) {
        final trackIdx = token.trackIndex;
        if (!LudoTrack.isSafe(trackIdx)) {
          final opponents = allTokens.where(
            (t) => t.player != token.player && t.step >= 0 && t.step <= 50 && t.trackIndex == trackIdx,
          ).toList();

          if (opponents.isNotEmpty) {
            for (final opp in opponents) {
              opp.step = -1;
            }
            bonusTurn = true;
            HapticService.heavy();
          }
        }
      }
      if (dice == 6) {
        bonusTurn = true;
      }
    }

    notifyListeners();

    if (bonusTurn) {
      _canRoll = true;
      _currentDice = null;
      notifyListeners();
      _checkBotTurn();
    } else {
      _passTurn();
    }
  }

  void _recordPlayerFinished(LudoPlayer player) {
    if (_finishedRankings.contains(player)) return;
    _finishedRankings.add(player);
    if (_finishedRankings.length >= activePlayers.length - 1) {
      final remaining = activePlayers.firstWhere(
        (p) => !_finishedRankings.contains(p),
      );
      _finishedRankings.add(remaining);
      _isGameOver = true;
      _winner = _finishedRankings.first;
      _canRoll = false;
      _isRolling = false;
      _movableTokens = [];
    }
  }

  void _passTurn() {
    _currentDice = null;
    _movableTokens = [];
    _canRoll = true;
    if (_isGameOver) return;
    int attempts = 0;
    do {
      _currentPlayerIndex = (_currentPlayerIndex + 1) % activePlayers.length;
      attempts++;
    } while (_finishedRankings.contains(currentPlayer) && attempts < activePlayers.length);
    notifyListeners();
    _checkBotTurn();
  }

  void _checkBotTurn() {
    if (_isGameOver || _isDisposed) return;
    if (_finishedRankings.contains(currentPlayer)) return;
    if (currentPlayerType == LudoPlayerType.bot && _canRoll) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!_isDisposed && !_isGameOver && !_finishedRankings.contains(currentPlayer) && currentPlayerType == LudoPlayerType.bot && _canRoll) {
          rollDice();
        }
      });
    }
  }

  void _handleBotMove() {
    if (_movableTokens.isEmpty || _isDisposed) return;

    LudoToken? bestToken;

    for (final t in _movableTokens) {
      if (t.step >= 0 && t.step + _currentDice! <= 50) {
        final targetIdx = (t.player.startIndex + t.step + _currentDice!) % 52;
        if (!LudoTrack.isSafe(targetIdx)) {
          final hitsOpponent = allTokens.any(
            (o) => o.player != t.player && o.step >= 0 && o.step <= 50 && o.trackIndex == targetIdx,
          );
          if (hitsOpponent) {
            bestToken = t;
            break;
          }
        }
      }
    }

    bestToken ??= _movableTokens.firstWhere(
      (t) => t.step + _currentDice! == 56,
      orElse: () => _movableTokens.firstWhere(
        (t) => t.isAtYard,
        orElse: () => _movableTokens.reduce(
          (a, b) => a.step > b.step ? a : b,
        ),
      ),
    );

    moveToken(bestToken);
  }

  bool _hasPlayerWon(LudoPlayer player) {
    return allTokens.where((t) => t.player == player).every((t) => t.isHome);
  }

  void triggerVictory([dynamic rankingOrWinner]) {
    if (_isGameOver || activePlayers.isEmpty) return;
    final List<LudoPlayer> order;
    if (rankingOrWinner is List<LudoPlayer> && rankingOrWinner.length == activePlayers.length) {
      order = List.from(rankingOrWinner);
    } else if (rankingOrWinner is LudoPlayer && activePlayers.contains(rankingOrWinner)) {
      final remaining = activePlayers.where((p) => p != rankingOrWinner).toList()..shuffle(_random);
      order = [rankingOrWinner, ...remaining];
    } else {
      final finished = List<LudoPlayer>.from(_finishedRankings);
      final remaining = activePlayers.where((p) => !finished.contains(p)).toList()..shuffle(_random);
      order = [...finished, ...remaining];
    }
    for (int i = 0; i < order.length - 1; i++) {
      final p = order[i];
      for (final token in allTokens.where((t) => t.player == p)) {
        token.step = 56;
      }
    }
    _finishedRankings = order;
    _isGameOver = true;
    _winner = order.first;
    _canRoll = false;
    _isRolling = false;
    _movableTokens = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
