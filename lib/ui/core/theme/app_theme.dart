import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.card,
    required this.bevel,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.boardBed,
    required this.trackCell,
    required this.trackBorder,
    required this.starColor,
    required this.diceInactive,
    required this.diceInactiveBevel,
    required this.diceInactiveDot,
    required this.locked,
    required this.lockedBevel,
    required this.lockedText,
    required this.mint,
    required this.mintBevel,
    required this.mintText,
    required this.sky,
    required this.skyBevel,
    required this.skyText,
    required this.peach,
    required this.peachBevel,
    required this.peachText,
    required this.butter,
    required this.butterBevel,
    required this.butterText,
  });

  final Color canvas;
  final Color surface;
  final Color card;
  final Color bevel;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color boardBed;
  final Color trackCell;
  final Color trackBorder;
  final Color starColor;
  final Color diceInactive;
  final Color diceInactiveBevel;
  final Color diceInactiveDot;
  final Color locked;
  final Color lockedBevel;
  final Color lockedText;
  final Color mint;
  final Color mintBevel;
  final Color mintText;
  final Color sky;
  final Color skyBevel;
  final Color skyText;
  final Color peach;
  final Color peachBevel;
  final Color peachText;
  final Color butter;
  final Color butterBevel;
  final Color butterText;

  static const light = AppColors(
    canvas: Color(0xFFFBF8F2),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    bevel: Color(0xFFDFD9CF),
    border: Color(0xFFEDE8DE),
    text: Color(0xFF282B37),
    textMuted: Color(0xFF7A7F92),
    boardBed: Color(0xFFE0DAD0),
    trackCell: Color(0xFFFFFFFF),
    trackBorder: Color(0xFFEDE8DE),
    starColor: Color(0xFF000000),
    diceInactive: Color(0xFFFFFFFF),
    diceInactiveBevel: Color(0xFFDFD9CF),
    diceInactiveDot: Color(0xFF282B37),
    locked: Color(0xFFE8E4DC),
    lockedBevel: Color(0xFFCBC4B7),
    lockedText: Color(0xFF8C867B),
    mint: Color(0xFF7ED9A4),
    mintBevel: Color(0xFF4FA876),
    mintText: Color(0xFF144D29),
    sky: Color(0xFF8DE0F0),
    skyBevel: Color(0xFF53B5C9),
    skyText: Color(0xFF0F4754),
    peach: Color(0xFFFF9F85),
    peachBevel: Color(0xFFE06F51),
    peachText: Color(0xFF5B1F11),
    butter: Color(0xFFFFDE6A),
    butterBevel: Color(0xFFE5BC32),
    butterText: Color(0xFF523D00),
  );

  static const dark = AppColors(
    canvas: Color(0xFF14161D),
    surface: Color(0xFF1F222B),
    card: Color(0xFF242833),
    bevel: Color(0xFF2E3342),
    border: Color(0xFF353B4D),
    text: Color(0xFFF0F2F8),
    textMuted: Color(0xFFA6ABB8),
    boardBed: Color(0xFF1A1C24),
    trackCell: Color(0xFF242833),
    trackBorder: Color(0xFF353B4D),
    starColor: Color(0xFFFFFFFF),
    diceInactive: Color(0xFF242833),
    diceInactiveBevel: Color(0xFF2E3342),
    diceInactiveDot: Color(0xFFF0F2F8),
    locked: Color(0xFF242833),
    lockedBevel: Color(0xFF1B1E26),
    lockedText: Color(0xFF6A7080),
    mint: Color(0xFF2E8B57),
    mintBevel: Color(0xFF1E5B38),
    mintText: Color(0xFFE8F5E9),
    sky: Color(0xFF2A7BC8),
    skyBevel: Color(0xFF1A548C),
    skyText: Color(0xFFE3F2FD),
    peach: Color(0xFFD9534F),
    peachBevel: Color(0xFF9E3633),
    peachText: Color(0xFFFFEBEE),
    butter: Color(0xFFD4A017),
    butterBevel: Color(0xFF99730F),
    butterText: Color(0xFFFFF8E1),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? canvas,
    Color? surface,
    Color? card,
    Color? bevel,
    Color? border,
    Color? text,
    Color? textMuted,
    Color? boardBed,
    Color? trackCell,
    Color? trackBorder,
    Color? starColor,
    Color? diceInactive,
    Color? diceInactiveBevel,
    Color? diceInactiveDot,
    Color? locked,
    Color? lockedBevel,
    Color? lockedText,
    Color? mint,
    Color? mintBevel,
    Color? mintText,
    Color? sky,
    Color? skyBevel,
    Color? skyText,
    Color? peach,
    Color? peachBevel,
    Color? peachText,
    Color? butter,
    Color? butterBevel,
    Color? butterText,
  }) {
    return AppColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      bevel: bevel ?? this.bevel,
      border: border ?? this.border,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      boardBed: boardBed ?? this.boardBed,
      trackCell: trackCell ?? this.trackCell,
      trackBorder: trackBorder ?? this.trackBorder,
      starColor: starColor ?? this.starColor,
      diceInactive: diceInactive ?? this.diceInactive,
      diceInactiveBevel: diceInactiveBevel ?? this.diceInactiveBevel,
      diceInactiveDot: diceInactiveDot ?? this.diceInactiveDot,
      locked: locked ?? this.locked,
      lockedBevel: lockedBevel ?? this.lockedBevel,
      lockedText: lockedText ?? this.lockedText,
      mint: mint ?? this.mint,
      mintBevel: mintBevel ?? this.mintBevel,
      mintText: mintText ?? this.mintText,
      sky: sky ?? this.sky,
      skyBevel: skyBevel ?? this.skyBevel,
      skyText: skyText ?? this.skyText,
      peach: peach ?? this.peach,
      peachBevel: peachBevel ?? this.peachBevel,
      peachText: peachText ?? this.peachText,
      butter: butter ?? this.butter,
      butterBevel: butterBevel ?? this.butterBevel,
      butterText: butterText ?? this.butterText,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      bevel: Color.lerp(bevel, other.bevel, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      boardBed: Color.lerp(boardBed, other.boardBed, t)!,
      trackCell: Color.lerp(trackCell, other.trackCell, t)!,
      trackBorder: Color.lerp(trackBorder, other.trackBorder, t)!,
      starColor: Color.lerp(starColor, other.starColor, t)!,
      diceInactive: Color.lerp(diceInactive, other.diceInactive, t)!,
      diceInactiveBevel: Color.lerp(diceInactiveBevel, other.diceInactiveBevel, t)!,
      diceInactiveDot: Color.lerp(diceInactiveDot, other.diceInactiveDot, t)!,
      locked: Color.lerp(locked, other.locked, t)!,
      lockedBevel: Color.lerp(lockedBevel, other.lockedBevel, t)!,
      lockedText: Color.lerp(lockedText, other.lockedText, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      mintBevel: Color.lerp(mintBevel, other.mintBevel, t)!,
      mintText: Color.lerp(mintText, other.mintText, t)!,
      sky: Color.lerp(sky, other.sky, t)!,
      skyBevel: Color.lerp(skyBevel, other.skyBevel, t)!,
      skyText: Color.lerp(skyText, other.skyText, t)!,
      peach: Color.lerp(peach, other.peach, t)!,
      peachBevel: Color.lerp(peachBevel, other.peachBevel, t)!,
      peachText: Color.lerp(peachText, other.peachText, t)!,
      butter: Color.lerp(butter, other.butter, t)!,
      butterBevel: Color.lerp(butterBevel, other.butterBevel, t)!,
      butterText: Color.lerp(butterText, other.butterText, t)!,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.canvas,
    extensions: const [AppColors.light],
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF009900),
      secondary: Color(0xFFFF4B4B),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF282B37),
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF282B37)),
      titleTextStyle: TextStyle(
        color: Color(0xFF282B37),
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: Color(0xFF282B37),
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Color(0xFF282B37),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFF282B37),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF282B37),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF282B37),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF7A7F92),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.light.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.light.bevel, width: 2),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.canvas,
    extensions: const [AppColors.dark],
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF009900),
      secondary: Color(0xFFFF4B4B),
      surface: Color(0xFF1F222B),
      onSurface: Color(0xFFF0F2F8),
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFFF0F2F8)),
      titleTextStyle: TextStyle(
        color: Color(0xFFF0F2F8),
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: Color(0xFFF0F2F8),
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Color(0xFFF0F2F8),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Color(0xFFF0F2F8),
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF0F2F8),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF0F2F8),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFA6ABB8),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.dark.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: AppColors.dark.bevel, width: 2),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    ),
  );
}
