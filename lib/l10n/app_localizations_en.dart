// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ludo';

  @override
  String get humans => 'HUMANS';

  @override
  String get bots => 'BOTS';

  @override
  String get play => 'Play';

  @override
  String get settings => 'Settings';

  @override
  String get themeSkin => 'Theme / Skin';

  @override
  String get themeSubtitle => 'Select app appearance mode';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get hapticSubtitle => 'Vibrate on dice, moves & taps';

  @override
  String get sound => 'Sound';

  @override
  String get soundSubtitle => 'Music and dice audio';

  @override
  String get on => 'ON';

  @override
  String get off => 'OFF';

  @override
  String playerTakesFirst(String playerName) {
    return '$playerName Takes #1!';
  }

  @override
  String get matchStandings => 'Match Standings';

  @override
  String get rankLoss => 'Loss';

  @override
  String rankPosition(int rank) {
    return '#$rank';
  }

  @override
  String playerNameWithBot(String playerName) {
    return '$playerName (Bot)';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get home => 'Home';

  @override
  String get leaveGameTitle => 'Leave Game?';

  @override
  String get leaveGameMessage => 'Current match progress will be lost.';

  @override
  String get stay => 'Stay';

  @override
  String get leave => 'Leave';

  @override
  String get playerRed => 'Red';

  @override
  String get playerGreen => 'Green';

  @override
  String get playerYellow => 'Yellow';

  @override
  String get playerBlue => 'Blue';
}
