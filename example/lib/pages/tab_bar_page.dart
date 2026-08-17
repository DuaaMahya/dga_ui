import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

/// Phone-ish width so the bar reads at its intended proportions on desktop.
const double _kPhoneWidth = 375;

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int _live = 0;
  int _three = 1;
  int _seven = 0;
  int _onColor = 2;
  int _badges = 0;

  static const _five = [
    DgaTabBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    DgaTabBarItem(icon: Icon(Icons.search), label: 'Search'),
    DgaTabBarItem(icon: Icon(Icons.bookmark_border), label: 'Saved'),
    DgaTabBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
    DgaTabBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
  ];

  /// Same tabs, but each swaps to a filled glyph once active.
  static const _fiveFilled = [
    DgaTabBarItem(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    DgaTabBarItem(
      icon: Icon(Icons.search),
      selectedIcon: Icon(Icons.saved_search),
      label: 'Search',
    ),
    DgaTabBarItem(
      icon: Icon(Icons.bookmark_border),
      selectedIcon: Icon(Icons.bookmark),
      label: 'Saved',
    ),
    DgaTabBarItem(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
    DgaTabBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
  ];

  static const _withBadges = [
    DgaTabBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    DgaTabBarItem(
      icon: Icon(Icons.mail_outline),
      label: 'Inbox',
      badge: DgaBadge.count(3),
    ),
    DgaTabBarItem(
      icon: Icon(Icons.notifications_none),
      label: 'Alerts',
      badge: DgaBadge.count(150),
    ),
    DgaTabBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      label: 'Chat',
      badge: DgaBadge.dot(),
    ),
    DgaTabBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
  ];

  /// The bar has no elevation of its own, so a light frame keeps it legible
  /// against the gallery background.
  Widget _frame(Widget bar) => SizedBox(
    width: _kPhoneWidth,
    child: ClipRRect(borderRadius: DgaRadius.brMd, child: bar),
  );

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaTabBar',
    children: [
      sectionHeader(context, 'Live — tap a tab'),
      sectionRow(
        _frame(
          DgaTabBar(
            items: _five,
            selectedIndex: _live,
            onChanged: (i) => setState(() => _live = i),
            // The gallery isn't screen-anchored, so no inset to reserve.
            safeArea: false,
          ),
        ),
      ),

      sectionHeader(context, 'Any number of tabs — the list decides'),
      sectionRow(
        _frame(
          DgaTabBar(
            items: _five.take(3).toList(),
            selectedIndex: _three,
            onChanged: (i) => setState(() => _three = i),
            safeArea: false,
          ),
        ),
      ),
      sectionRow(
        _frame(
          DgaTabBar(
            items: [
              ..._five,
              const DgaTabBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
              const DgaTabBarItem(
                icon: Icon(Icons.help_outline),
                label: 'Help',
              ),
            ],
            selectedIndex: _seven,
            onChanged: (i) => setState(() => _seven = i),
            safeArea: false,
          ),
        ),
      ),

      sectionHeader(context, 'On color'),
      sectionRow(
        _frame(
          DgaTabBar(
            items: _five,
            selectedIndex: _onColor,
            onChanged: (i) => setState(() => _onColor = i),
            onColor: true,
            safeArea: false,
          ),
        ),
      ),

      sectionHeader(context, 'Badges — dot, count, and capped count'),
      sectionRow(
        _frame(
          DgaTabBar(
            items: _withBadges,
            selectedIndex: _badges,
            onChanged: (i) => setState(() => _badges = i),
            safeArea: false,
          ),
        ),
      ),

      sectionHeader(context, 'Optional selected icon (outline to filled)'),
      sectionRow(
        _frame(
          DgaTabBar(
            items: _fiveFilled,
            selectedIndex: _live,
            onChanged: (i) => setState(() => _live = i),
            safeArea: false,
          ),
        ),
      ),

      sectionHeader(context, 'Nothing selected'),
      sectionRow(
        _frame(
          DgaTabBar(
            items: _five,
            selectedIndex: null,
            onChanged: (_) {},
            safeArea: false,
          ),
        ),
      ),

      sectionHeader(context, 'RTL'),
      sectionRow(
        Directionality(
          textDirection: TextDirection.rtl,
          child: _frame(
            DgaTabBar(
              items: const [
                DgaTabBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'الرئيسية',
                ),
                DgaTabBarItem(
                  icon: Icon(Icons.mail_outline),
                  label: 'الرسائل',
                  badge: DgaBadge.count(150),
                ),
                DgaTabBarItem(
                  icon: Icon(Icons.bookmark_border),
                  label: 'المحفوظات',
                ),
                DgaTabBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
              ],
              selectedIndex: 1,
              onChanged: (_) {},
              safeArea: false,
            ),
          ),
        ),
      ),

      sectionHeader(context, 'DgaBadge on its own'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            DgaBadge.dot(),
            DgaBadge.count(1),
            DgaBadge.count(9),
            DgaBadge.count(42),
            DgaBadge.count(150),
            DgaBadge.count(150, maxCount: 9),
          ],
        ),
      ),
    ],
  );
}
