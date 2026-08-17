import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '../widgets/settings_app_bar.dart';
import 'button_page.dart';
import 'chip_page.dart';
import 'close_button_page.dart';
import 'floating_button_page.dart';
import 'link_page.dart';
import 'accordion_page.dart';
import 'avatar_page.dart';
import 'calendar_page.dart';
import 'card_page.dart';
import 'carousel_page.dart';
import 'checkbox_page.dart';
import 'date_picker_page.dart';
import 'inline_alert_page.dart';
import 'notification_toast_page.dart';
import 'content_switcher_page.dart';
import 'dropdown_page.dart';
import 'menu_button_page.dart';
import 'progress_page.dart';
import 'quote_page.dart';
import 'radio_page.dart';
import 'rating_page.dart';
import 'status_tag_page.dart';
import 'slider_page.dart';
import 'switch_page.dart';
import 'tab_bar_page.dart';
import 'tabs_page.dart';
import 'tag_page.dart';
import 'text_input_page.dart';
import 'textarea_page.dart';
import 'tooltip_page.dart';
import 'notification_page.dart';

enum _Category {
  actions('Actions'),
  forms('Forms & Inputs'),
  dataDisplay('Data Display'),
  navigation('Navigation'),
  feedback('Feedback');

  const _Category(this.label);
  final String label;
}

class _ComponentEntry {
  const _ComponentEntry({
    required this.name,
    required this.blurb,
    required this.icon,
    required this.category,
    required this.builder,
  });
  final String name;
  final String blurb;
  final IconData icon;
  final _Category category;
  final WidgetBuilder builder;
  bool matches(String query) =>
      name.toLowerCase().contains(query) || blurb.toLowerCase().contains(query);
}

final _entries = <_ComponentEntry>[
  // Actions
  _ComponentEntry(
    name: 'Button',
    blurb: 'Primary CTA — 6 styles × 3 sizes',
    icon: Icons.smart_button_outlined,
    category: _Category.actions,
    builder: (_) => const ButtonPage(),
  ),
  _ComponentEntry(
    name: 'Menu Button',
    blurb: 'Button that opens a menu (chevron)',
    icon: Icons.expand_more,
    category: _Category.actions,
    builder: (_) => const MenuButtonPage(),
  ),
  _ComponentEntry(
    name: 'Close Button',
    blurb: '× affordance in 4 fixed sizes',
    icon: Icons.close,
    category: _Category.actions,
    builder: (_) => const CloseButtonPage(),
  ),
  _ComponentEntry(
    name: 'Floating Button',
    blurb: 'FAB — icon-only or extended',
    icon: Icons.add_circle_outline,
    category: _Category.actions,
    builder: (_) => const FloatingButtonPage(),
  ),
  _ComponentEntry(
    name: 'Link',
    blurb: 'Inline & standalone text link',
    icon: Icons.link,
    category: _Category.actions,
    builder: (_) => const LinkPage(),
  ),

  // Forms & Inputs
  _ComponentEntry(
    name: 'Text Input',
    blurb: 'Field with center-expand focus underline',
    icon: Icons.text_fields,
    category: _Category.forms,
    builder: (_) => const TextInputPage(),
  ),
  _ComponentEntry(
    name: 'Textarea',
    blurb: 'Multi-line input, resizable',
    icon: Icons.notes,
    category: _Category.forms,
    builder: (_) => const TextareaPage(),
  ),
  _ComponentEntry(
    name: 'Dropdown Input',
    blurb: 'Select field with a popover option list',
    icon: Icons.arrow_drop_down_circle_outlined,
    category: _Category.forms,
    builder: (_) => const DropdownPage(),
  ),
  _ComponentEntry(
    name: 'Switch',
    blurb: 'On/off toggle with animated thumb',
    icon: Icons.toggle_on_outlined,
    category: _Category.forms,
    builder: (_) => const SwitchPage(),
  ),
  _ComponentEntry(
    name: 'Radio',
    blurb: 'Single-select from a group',
    icon: Icons.radio_button_unchecked,
    category: _Category.forms,
    builder: (_) => const RadioPage(),
  ),
  _ComponentEntry(
    name: 'Checkbox',
    blurb: 'Checked / indeterminate, with labels',
    icon: Icons.check_box_outlined,
    category: _Category.forms,
    builder: (_) => const CheckboxPage(),
  ),
  _ComponentEntry(
    name: 'Rating Star',
    blurb: 'Tap-to-rate with half stars',
    icon: Icons.star_outline,
    category: _Category.forms,
    builder: (_) => const RatingPage(),
  ),
  _ComponentEntry(
    name: 'Sliders',
    blurb: 'Single-value and range sliders',
    icon: Icons.swap_horizontal_circle_outlined,
    category: _Category.forms,
    builder: (_) => const SliderPage(),
  ),
  _ComponentEntry(
    name: 'Date Picker Input',
    blurb: 'Typeable date field that opens a calendar below it',
    icon: Icons.calendar_today_outlined,
    category: _Category.forms,
    builder: (_) => const DatePickerPage(),
  ),
  _ComponentEntry(
    name: 'Calendar',
    blurb: 'Standalone month grid — single date or range',
    icon: Icons.calendar_month_outlined,
    category: _Category.forms,
    builder: (_) => const CalendarPage(),
  ),

  // Data Display
  _ComponentEntry(
    name: 'Chip',
    blurb: 'Interactive filter / selection chip',
    icon: Icons.label_outline,
    category: _Category.dataDisplay,
    builder: (_) => const ChipPage(),
  ),
  _ComponentEntry(
    name: 'Tag',
    blurb: 'Static semantic labels',
    icon: Icons.local_offer_outlined,
    category: _Category.dataDisplay,
    builder: (_) => const TagPage(),
  ),
  _ComponentEntry(
    name: 'Status Tag',
    blurb: 'Color-coded status pill',
    icon: Icons.circle_outlined,
    category: _Category.dataDisplay,
    builder: (_) => const StatusTagPage(),
  ),
  _ComponentEntry(
    name: 'Avatar',
    blurb: 'Image, initials, or icon; circle/square',
    icon: Icons.account_circle_outlined,
    category: _Category.dataDisplay,
    builder: (_) => const AvatarPage(),
  ),
  _ComponentEntry(
    name: 'Card',
    blurb: 'Reusable surface with hover/press + selectable state',
    icon: Icons.view_agenda_outlined,
    category: _Category.dataDisplay,
    builder: (_) => const CardPage(),
  ),
  _ComponentEntry(
    name: 'Quote',
    blurb: 'Pull-quote with accent + author',
    icon: Icons.format_quote_outlined,
    category: _Category.dataDisplay,
    builder: (_) => const QuotePage(),
  ),

  // Navigation
  _ComponentEntry(
    name: 'Tab Bar',
    blurb: 'Mobile bottom nav — any tab count, badges, on-color',
    icon: Icons.space_dashboard_outlined,
    category: _Category.navigation,
    builder: (_) => const TabBarPage(),
  ),
  _ComponentEntry(
    name: 'Tabs',
    blurb: 'Horizontal + vertical tab items',
    icon: Icons.tab_outlined,
    category: _Category.navigation,
    builder: (_) => const TabsPage(),
  ),
  _ComponentEntry(
    name: 'Accordion',
    blurb: 'Expandable disclosure panel',
    icon: Icons.unfold_more,
    category: _Category.navigation,
    builder: (_) => const AccordionPage(),
  ),
  _ComponentEntry(
    name: 'Content Switcher',
    blurb: 'Segmented control for switching views',
    icon: Icons.view_week_outlined,
    category: _Category.navigation,
    builder: (_) => const ContentSwitcherPage(),
  ),
  _ComponentEntry(
    name: 'Carousel',
    blurb: 'Swipeable slides with dot indicators',
    icon: Icons.view_carousel_outlined,
    category: _Category.navigation,
    builder: (_) => const CarouselPage(),
  ),

  // Feedback
  _ComponentEntry(
    name: 'Tooltip',
    blurb: 'Hover/long-press bubble that auto-places itself',
    icon: Icons.info_outline,
    category: _Category.feedback,
    builder: (_) => const TooltipPage(),
  ),
  _ComponentEntry(
    name: 'Progress & Steppers',
    blurb: 'Linear/circular progress + steppers',
    icon: Icons.donut_large_outlined,
    category: _Category.feedback,
    builder: (_) => const ProgressPage(),
  ),
  _ComponentEntry(
    name: 'Inline Alert',
    blurb: 'In-page banner — 5 severities, white or tinted',
    icon: Icons.announcement_outlined,
    category: _Category.feedback,
    builder: (_) => const InlineAlertPage(),
  ),
  _ComponentEntry(
    name: 'Notification Toast',
    blurb: 'Floating card — placement, queueing and auto-dismiss',
    icon: Icons.campaign_outlined,
    category: _Category.feedback,
    builder: (_) => const NotificationToastPage(),
  ),
  _ComponentEntry(
    name: 'Notification',
    blurb: 'Superseded by Inline Alert — kept for compatibility',
    icon: Icons.notifications_none,
    category: _Category.feedback,
    builder: (_) => const NotificationPage(),
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = DgaTheme.of(context).colors;
    final query = _query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _entries
        : _entries.where((e) => e.matches(query)).toList();

    final byCategory = <_Category, List<_ComponentEntry>>{};
    for (final entry in filtered) {
      byCategory.putIfAbsent(entry.category, () => []).add(entry);
    }
    final categoriesWithEntries = _Category.values
        .where(byCategory.containsKey)
        .toList();
    // Browsing (no query): collapse everything behind accordions so the page
    // stays a fixed, small height no matter how many components exist — only
    // the first category opens by default. Searching: skip the accordions
    // entirely so every match is visible without an extra click.
    final searching = query.isNotEmpty;

    return Scaffold(
      appBar: const SettingsAppBar(title: 'DGA UI Gallery'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: DgaSpacing.xl,
                end: DgaSpacing.xl,
                top: DgaSpacing.xl3,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'DGA Components',
                        style: DgaTypography.displayXs.semibold,
                      ),
                      const SizedBox(width: DgaSpacing.md),
                      _CountPill(count: _entries.length, colors: colors),
                    ],
                  ),
                  const SizedBox(height: DgaSpacing.xs),
                  Text(
                    'A living catalog of every DGA design-system component.',
                    style: DgaTypography.textSm.regular.copyWith(
                      color: colors.textSecondaryParagraph,
                    ),
                  ),
                  const SizedBox(height: DgaSpacing.xl2),
                  DgaTextInput(
                    controller: _searchController,
                    hintText: 'Search components…',
                    size: DgaTextInputSize.medium,
                    leadingIcon: const Icon(Icons.search),
                    clearable: true,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: DgaSpacing.xl3),
            if (filtered.isEmpty)
              _EmptySearchState(query: _searchController.text, colors: colors)
            else
              for (final category in categoriesWithEntries)
                _CategorySection(
                  key: ValueKey('${category.name}-$searching'),
                  category: category,
                  entries: byCategory[category]!,
                  colors: colors,
                  collapsible: !searching,
                  isFirst: category == categoriesWithEntries.first,
                ),
          ],
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count, required this.colors});

  final int count;
  final DgaSemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DgaSpacing.md,
        vertical: DgaSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundPrimary50,
        borderRadius: DgaRadius.brFull,
        border: Border.all(color: colors.borderPrimaryLight),
      ),
      child: Text(
        '$count and counting',
        style: DgaTypography.textXs.semibold.copyWith(
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    super.key,
    required this.category,
    required this.entries,
    required this.colors,
    required this.collapsible,
    required this.isFirst,
  });

  final _Category category;
  final List<_ComponentEntry> entries;
  final DgaSemanticColors colors;

  /// True while browsing (no active search) — wraps the grid in a collapsed
  /// [DgaAccordion] so the page height doesn't grow with the catalog. False
  /// while searching, where every match should be visible at once.
  final bool collapsible;
  final bool isFirst;

  Widget _grid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          < 560 => 1,
          < 900 => 2,
          < 1300 => 3,
          _ => 4,
        };
        const gap = DgaSpacing.lg;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final entry in entries)
              SizedBox(
                width: cardWidth,
                child: DgaCard(
                  text: entry.name,
                  helperText: entry.blurb,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: entry.builder)),
                  icon: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.backgroundNeutral100,
                      borderRadius: DgaRadius.brMd,
                    ),
                    child: Icon(
                      entry.icon,
                      size: 20,
                      color: colors.iconDefault,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (collapsible) {
      return DgaAccordion(
        title: '${category.label} (${entries.length})',
        isFirst: isFirst,
        initiallyExpanded: isFirst,
        child: _grid(context),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: DgaSpacing.lg,
        left: DgaSpacing.xl,
        right: DgaSpacing.xl,
        bottom: DgaSpacing.xl3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                category.label,
                style: DgaTypography.textMd.semibold.copyWith(
                  color: colors.textDisplay,
                ),
              ),
              const SizedBox(width: DgaSpacing.xs),
              Text(
                '${entries.length}',
                style: DgaTypography.textSm.regular.copyWith(
                  color: colors.textSecondaryParagraph,
                ),
              ),
            ],
          ),
          const SizedBox(height: DgaSpacing.md),
          _grid(context),
        ],
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState({required this.query, required this.colors});

  final String query;
  final DgaSemanticColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DgaSpacing.xl6),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 32, color: colors.iconDefaultDisabled),
          const SizedBox(height: DgaSpacing.md),
          Text(
            'No components match "$query"',
            style: DgaTypography.textMd.medium.copyWith(
              color: colors.textDisplay,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DgaSpacing.xs),
          Text(
            'Try a different name or clear the search.',
            style: DgaTypography.textSm.regular.copyWith(
              color: colors.textSecondaryParagraph,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
