import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _h = 0;
  int _v = 1;

  static const _labels = ['Overview', 'Activity', 'Settings', 'Billing'];

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'Tabs',
    children: [
      sectionHeader(
        context,
        'Horizontal — sizes (tap to select, scrolls if it overflows)',
      ),
      for (final size in DgaHorizontalTabSize.values)
        sectionRow(
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < _labels.length; i++)
                  DgaHorizontalTab(
                    label: _labels[i],
                    selected: _h == i,
                    size: size,
                    onTap: () => setState(() => _h = i),
                  ),
              ],
            ),
          ),
        ),
      sectionHeader(context, 'Horizontal — with icon + disabled'),
      sectionRow(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DgaHorizontalTab(
                label: 'Home',
                selected: _h == 0,
                leadingIcon: const Icon(Icons.home),
                onTap: () => setState(() => _h = 0),
              ),
              DgaHorizontalTab(
                label: 'Search',
                selected: _h == 1,
                leadingIcon: const Icon(Icons.search),
                onTap: () => setState(() => _h = 1),
              ),
              DgaHorizontalTab(
                label: 'Disabled',
                selected: false,
                disabled: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
      sectionHeader(
        context,
        'Vertical (start-edge indicator, flips under RTL)',
      ),
      sectionRow(
        SizedBox(
          width: 240,
          child: Column(
            children: [
              for (var i = 0; i < _labels.length; i++) ...[
                DgaVerticalTab(
                  label: _labels[i],
                  selected: _v == i,
                  onTap: () => setState(() => _v = i),
                ),
                const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ),
    ],
  );
}
