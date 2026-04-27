import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:marketplace/core/constants/app_strings.dart';

import '../constants/app_constants.dart';

/// Opens WhatsApp chat with [AppConstants.supportWhatsAppWaMeDigits].
Future<void> openSupportWhatsApp(BuildContext? context) async {
  final uri = Uri.parse(
    'https://wa.me/${AppConstants.supportWhatsAppWaMeDigits}',
  );
  try {
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context != null && context.mounted) {
      _showCouldNotOpen(context);
    }
  } catch (_) {
    if (context != null && context.mounted) {
      _showCouldNotOpen(context);
    }
  }
}

void _showCouldNotOpen(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppStrings.couldNotOpenWhatsApp),
    ),
  );
}
