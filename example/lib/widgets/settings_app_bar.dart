import 'package:flutter/material.dart';

import '../settings.dart';

/// AppBar with the Dark / On-color / RTL switches — shared by every page so
/// changing a setting on the detail page persists back to Home.
class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final s = GallerySettingsScope.of(context);
    return AppBar(
      title: Text(title),
      actions: [
        const Text('Dark'),
        Switch(value: s.dark, onChanged: (v) => s.dark = v),
        const SizedBox(width: 4),
        const Text('On-color'),
        Switch(value: s.onColor, onChanged: (v) => s.onColor = v),
        const SizedBox(width: 4),
        const Text('RTL'),
        Switch(value: s.rtl, onChanged: (v) => s.rtl = v),
        const SizedBox(width: 12),
      ],
    );
  }
}
