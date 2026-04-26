import 'package:flutter/material.dart';

void showAdhanBanner(
  BuildContext context,
  String prayerName, {
  required VoidCallback onStop,
}) {
  if (!context.mounted) return;
  final messenger = ScaffoldMessenger.of(context);

  messenger.showMaterialBanner(
    MaterialBanner(
      backgroundColor: const Color(0xFF1B6B45),
      padding: const EdgeInsets.all(16),
      content: Text(
        'حان وقت $prayerName 🕌',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: const Icon(Icons.mosque_rounded, color: Colors.white),
      actions: [
        TextButton(
          onPressed: () {
            messenger.hideCurrentMaterialBanner();
            onStop();
          },
          child: const Text(
            '🔇 إيقاف الأذان',
            style: TextStyle(color: Color(0xFFD4AF37)),
          ),
        ),
      ],
    ),
  );
}
