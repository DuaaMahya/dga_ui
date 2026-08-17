import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class ContentSwitcherPage extends StatefulWidget {
  const ContentSwitcherPage({super.key});

  @override
  State<ContentSwitcherPage> createState() => _ContentSwitcherPageState();
}

class _ContentSwitcherPageState extends State<ContentSwitcherPage> {
  int _a = 0;
  int _b = 1;

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaContentSwitcher',
    children: [
      sectionHeader(context, 'Sizes'),
      for (final size in DgaContentSwitcherSize.values)
        sectionRow(
          DgaContentSwitcher(
            segments: const ['Day', 'Week', 'Month'],
            selectedIndex: _a,
            size: size,
            onChanged: (i) => setState(() => _a = i),
          ),
        ),
      sectionHeader(context, 'Two segments'),
      sectionRow(
        DgaContentSwitcher(
          segments: const ['☰ List', '☷ Grid'],
          selectedIndex: _b,
          onChanged: (i) => setState(() => _b = i),
        ),
      ),
    ],
  );
}
