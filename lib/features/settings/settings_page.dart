import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:marketplace/core/constants/app_constants.dart';
import 'package:marketplace/core/providers/localization_provider.dart';
import 'package:marketplace/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = context.watch<LocalizationProvider>();
    final isArabic = locale.isArabic;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildLanguageTile(
            context: context,
            title: l10n.selectLanguage,
            subtitle: isArabic ? l10n.arabic : l10n.english,
            icon: Icons.language,
            onTap: () => _showLanguageDialog(context, l10n),
          ),
          const Divider(),
          _buildInfoTile(
            icon: Icons.info_outline,
            title: l10n.appVersion,
            subtitle: _version.isEmpty ? '...' : _version,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                  title: Text(l10n.english),
                  onTap: () {
                    context.read<LocalizationProvider>().setLanguage('en');
                    Navigator.pop(dialogContext);
                  },
                ),
                ListTile(
                  leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
                  title: Text(l10n.arabic),
                  onTap: () {
                    context.read<LocalizationProvider>().setLanguage('ar');
                    Navigator.pop(dialogContext);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
