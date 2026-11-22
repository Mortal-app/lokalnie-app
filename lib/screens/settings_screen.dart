import 'package:flutter/material.dart';

import '../app_info.dart';
import '../l10n/app_localizations.dart';
import '../models/widzew_skin.dart';
import '../theme/widzew_ui.dart';
import '../widgets/app_page_route.dart';
import '../widgets/route_pop_scope.dart';
import 'about_screen.dart';
import 'privacy_terms_screen.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final WidzewSkin widzewSkin;
  final ValueChanged<WidzewSkin> onWidzewSkinChanged;
  final VoidCallback onRestoreDefaults;
  final VoidCallback onVersionTileTap;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.widzewSkin,
    required this.onWidzewSkinChanged,
    required this.onRestoreDefaults,
    required this.onVersionTileTap,
  });

  Future<void> _confirmRestore(BuildContext context) async {
    final shouldRestore = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('confirmClearTitle')),
        content: Text(dialogContext.tr('confirmClearBody')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.tr('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.tr('clear')),
          ),
        ],
      ),
    );
    if (!context.mounted || shouldRestore != true) return;
    onRestoreDefaults();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedSkin = WidzewSkinX.palette.firstWhere(
      (skin) => skin.seed == theme.colorScheme.primary,
      orElse: () => widzewSkin,
    );
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: Text(context.tr('settingsTitle')),
      ),
      body: ListView(
        key: const ValueKey('settings-list'),
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          SwitchListTile(
            key: const ValueKey('dark-mode-switch'),
            secondary: Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            title: Text(context.tr('darkMode')),
            subtitle: Text(
              isDark ? context.tr('darkOn') : context.tr('darkOff'),
            ),
            value: isDark,
            onChanged: onThemeChanged,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              context.tr('colorPalette'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                for (final skin in WidzewSkinX.palette)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: skin.seed,
                      radius: 14,
                    ),
                    title: Text(
                      skin.label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    selected: selectedSkin == skin,
                    trailing: selectedSkin == skin
                        ? Icon(Icons.check, color: skin.seed)
                        : null,
                    shape: WidzewUi.shape,
                    onTap: () => onWidzewSkinChanged(skin),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined),
            title: Text(context.tr('cache')),
            subtitle: Text(context.tr('cacheHint')),
            onTap: () => _confirmRestore(context),
          ),
          ListTile(
            leading: const Icon(Icons.verified_outlined),
            title: Text(context.tr('appVersion')),
            subtitle: const Text(AppInfo.fullVersion),
            onTap: onVersionTileTap,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.tr('aboutApp')),
            subtitle: Text(context.tr('aboutHint')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context)
                .push(AppPageRoute<void>(builder: (_) => const AboutScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(context.tr('privacy')),
            subtitle: Text(context.tr('privacyHint')),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              AppPageRoute<void>(builder: (_) => const PrivacyTermsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
