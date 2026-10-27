import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../main.dart';
import '../../../../services/audio_service.dart';
import '../../../../services/haptic_service.dart';
import '../../../../services/storage_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tangible_widgets.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  ThemeMode _currentMode = ThemeMode.system;
  bool _hapticEnabled = true;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _currentMode = themeModeNotifier.value;
    _hapticEnabled = HapticService.isEnabled;
    _soundEnabled = AudioService.isEnabled;
  }

  Future<void> _updateTheme(ThemeMode mode) async {
    HapticService.selection();
    setState(() {
      _currentMode = mode;
    });
    themeModeNotifier.value = mode;
    await StorageService.setThemeMode(mode);
  }

  Future<void> _toggleHaptics(bool enabled) async {
    setState(() {
      _hapticEnabled = enabled;
    });
    await HapticService.setEnabled(enabled);
  }

  Future<void> _toggleSound(bool enabled) async {
    setState(() {
      _soundEnabled = enabled;
    });
    await AudioService.setEnabled(enabled);
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
              icon: Icons.arrow_back_rounded,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          l10n.settings,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: colors.text,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TangibleCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colors.sky.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.palette_rounded,
                            color: colors.skyText,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.themeSkin,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: colors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.themeSubtitle,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildThemeOption(
                            label: l10n.light,
                            icon: Icons.light_mode_rounded,
                            mode: ThemeMode.light,
                            colors: colors,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildThemeOption(
                            label: l10n.dark,
                            icon: Icons.dark_mode_rounded,
                            mode: ThemeMode.dark,
                            colors: colors,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildThemeOption(
                            label: l10n.system,
                            icon: Icons.brightness_auto_rounded,
                            mode: ThemeMode.system,
                            colors: colors,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TangibleCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.peach.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.vibration_rounded,
                        color: colors.peachText,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.hapticFeedback,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.hapticSubtitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TangibleButton(
                      width: 76,
                      height: 44,
                      padding: EdgeInsets.zero,
                      color: _hapticEnabled ? colors.mint : colors.canvas,
                      bevelColor: _hapticEnabled ? colors.mintBevel : colors.bevel,
                      elevation: 3,
                      onPressed: () => _toggleHaptics(!_hapticEnabled),
                      child: Text(
                        _hapticEnabled ? l10n.on : l10n.off,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: _hapticEnabled ? colors.mintText : colors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TangibleCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.butter.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.volume_up_rounded,
                        color: colors.butterText,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sound,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.soundSubtitle,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TangibleButton(
                      width: 76,
                      height: 44,
                      padding: EdgeInsets.zero,
                      color: _soundEnabled ? colors.mint : colors.canvas,
                      bevelColor: _soundEnabled ? colors.mintBevel : colors.bevel,
                      elevation: 3,
                      onPressed: () => _toggleSound(!_soundEnabled),
                      child: Text(
                        _soundEnabled ? l10n.on : l10n.off,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: _soundEnabled ? colors.mintText : colors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required IconData icon,
    required ThemeMode mode,
    required AppColors colors,
  }) {
    final isSelected = _currentMode == mode;

    return TangibleButton(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      color: isSelected ? colors.mint : colors.canvas,
      bevelColor: isSelected ? colors.mintBevel : colors.bevel,
      elevation: isSelected ? 4 : 2,
      onPressed: () => _updateTheme(mode),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? colors.mintText : colors.text,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: isSelected ? colors.mintText : colors.text,
            ),
          ),
        ],
      ),
    );
  }
}
