  import 'package:flutter/material.dart';

Widget errorView(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(fontSize: 14, color: Colors.red)),
        ],
      ),
    );
  }