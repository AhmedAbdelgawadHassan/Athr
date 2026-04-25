import 'package:athr/core/services/notification_service.dart';
import 'package:flutter/material.dart';

void showAdhanBanner(BuildContext context, String prayerName) {
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
          onPressed: () async {
            messenger.hideCurrentMaterialBanner();
            // ✅ الدالة الصح
            await NotificationService.instance.cancelAllAdhan();
          },
          child: const Text(
            'إغلاق',
            style: TextStyle(color: Color(0xFFD4AF37)),
          ),
        ),
      ],
    ),
  );
}