import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import 'dga_calendar_enums.dart';

/// Natural panel width from Figma (424) and the 7-column grid inside it
/// (424 − 2×16 padding = 392 = 7 × 56).
const double _kMaxPanelWidth = 424;
const double _kMaxSlot = 56;
const double _kCircleRatio = 48 / 56;
const double _kHeaderHeight = 40;
const double _kWeekdayRowHeight = 48;
const int _kGridRows = 6;

/// Standalone calendar surface.
///
/// Usable on its own (inline in a form, inside a sheet) or hosted in a
/// popover by `DgaDatePickerInput`. Single-date and range selection are two
/// named constructors rather than an enum because the *value type* differs —
/// an enum couldn't keep `onChanged` type-safe.
class DgaCalendar extends StatefulWidget {
  const DgaCalendar.single({
    super.key,
    DateTime? value,
    required ValueChanged<DateTime?> onChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.initialMonth,
  }) : isRange = false,
       singleValue = value,
       rangeValue = null,
       onSingleChanged = onChanged,
       onRangeChanged = null;

  const DgaCalendar.range({
    super.key,
    DgaDateRange? value,
    required ValueChanged<DgaDateRange?> onChanged,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    this.initialMonth,
  }) : isRange = true,
       singleValue = null,
       rangeValue = value,
       onSingleChanged = null,
       onRangeChanged = onChanged;

  final bool isRange;
  final DateTime? singleValue;
  final DgaDateRange? rangeValue;
  final ValueChanged<DateTime?>? onSingleChanged;
  final ValueChanged<DgaDateRange?>? onRangeChanged;

  /// Earliest selectable day (inclusive). Days before it render disabled.
  final DateTime? firstDate;

  /// Latest selectable day (inclusive).
  final DateTime? lastDate;

  /// Per-day veto, applied on top of [firstDate]/[lastDate].
  final bool Function(DateTime day)? selectableDayPredicate;

  /// Month shown on first build. Defaults to the selected date's month, or
  /// today's.
  final DateTime? initialMonth;

  @override
  State<DgaCalendar> createState() => _DgaCalendarState();
}

class _DgaCalendarState extends State<DgaCalendar> {
  late DateTime _month;
  bool _yearListOpen = false;

  /// While picking a range the first tap lands here; the second tap completes
  /// it. Kept locally so the parent only ever sees complete transitions.
  DateTime? _pendingRangeStart;

  @override
  void initState() {
    super.initState();
    _month = DgaCalendarSystem.firstDayOfMonth(_anchorMonth());
  }

  @override
  void didUpdateWidget(covariant DgaCalendar old) {
    super.didUpdateWidget(old);
    // Follow the value when the parent moves it somewhere we're not showing
    // (e.g. the user typed a date into the picker field).
    final anchor = _anchorMonth();
    if (!DgaCalendarSystem.isSameMonth(anchor, _month) &&
        (widget.singleValue != old.singleValue ||
            widget.rangeValue != old.rangeValue)) {
      _month = DgaCalendarSystem.firstDayOfMonth(anchor);
    }
  }

  DateTime _anchorMonth() =>
      widget.initialMonth ??
      widget.singleValue ??
      widget.rangeValue?.start ??
      DateTime.now();

  bool _isSelectable(DateTime day) {
    final d = DgaCalendarSystem.dateOnly(day);
    if (widget.firstDate != null &&
        d.isBefore(DgaCalendarSystem.dateOnly(widget.firstDate!))) {
      return false;
    }
    if (widget.lastDate != null &&
        d.isAfter(DgaCalendarSystem.dateOnly(widget.lastDate!))) {
      return false;
    }
    return widget.selectableDayPredicate?.call(d) ?? true;
  }

  void _pickDay(DateTime day) {
    final d = DgaCalendarSystem.dateOnly(day);
    if (!widget.isRange) {
      widget.onSingleChanged!(d);
      return;
    }

    final pending = _pendingRangeStart;
    if (pending == null) {
      // First tap: start a fresh range, clearing any previous one.
      setState(() => _pendingRangeStart = d);
      widget.onRangeChanged!(DgaDateRange(start: d));
      return;
    }

    // Second tap completes it — ordered, so picking backwards still works.
    setState(() => _pendingRangeStart = null);
    final ordered = d.isBefore(pending)
        ? DgaDateRange(start: d, end: pending)
        : DgaDateRange(start: pending, end: d);
    widget.onRangeChanged!(ordered);
  }

  void _shiftMonth(int delta) =>
      setState(() => _month = DgaCalendarSystem.addMonths(_month, delta));

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _kMaxPanelWidth;
        final slot = math.min(
          _kMaxSlot,
          (math.min(_kMaxPanelWidth, available) - DgaSpacing.xl * 2) / 7,
        );
        final panelWidth = slot * 7 + DgaSpacing.xl * 2;

        return Container(
          width: panelWidth,
          padding: const EdgeInsets.all(DgaSpacing.xl),
          decoration: BoxDecoration(
            color: c.fieldBackgroundDefault,
            borderRadius: DgaRadius.brMd,
            boxShadow: DgaShadows.xl2,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [_header(c), _weekdayRow(c, slot), _grid(c, slot)],
              ),
              if (_yearListOpen)
                Positioned(
                  top: _kHeaderHeight,
                  child: _YearList(
                    colors: c,
                    selectedYear: _month.year,
                    firstYear:
                        widget.firstDate?.year ?? DateTime.now().year - 100,
                    lastYear:
                        widget.lastDate?.year ?? DateTime.now().year + 100,
                    onPicked: (y) => setState(() {
                      _month = DateTime(y, _month.month);
                      _yearListOpen = false;
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(DgaSemanticColors c) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: _kHeaderHeight,
      child: Row(
        children: [
          Semantics(
            button: true,
            // `container` so this reads as one node; without it the inner
            // month Text supplies the label and the control is announced as
            // plain text rather than a button.
            container: true,
            label: '${DgaCalendarSystem.monthLabel(_month)}, select year',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _yearListOpen = !_yearListOpen),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DgaCalendarSystem.monthLabel(_month),
                    style: DgaTypography.textMd.medium.copyWith(
                      color: c.textDefault,
                    ),
                  ),
                  const SizedBox(width: DgaSpacing.xs),
                  AnimatedRotation(
                    turns: _yearListOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: c.iconDefault,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // "Previous" always points to the leading edge, so the pair flips
          // correctly under RTL.
          _NavButton(
            icon: rtl ? Icons.arrow_forward : Icons.arrow_back,
            tooltip: 'Previous month',
            color: c.iconDefault,
            onTap: () => _shiftMonth(-1),
          ),
          const SizedBox(width: DgaSpacing.md),
          _NavButton(
            icon: rtl ? Icons.arrow_back : Icons.arrow_forward,
            tooltip: 'Next month',
            color: c.iconDefault,
            onTap: () => _shiftMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _weekdayRow(DgaSemanticColors c, double slot) {
    return SizedBox(
      height: _kWeekdayRowHeight,
      child: Row(
        children: [
          for (final label in DgaCalendarSystem.weekdayAbbreviations)
            SizedBox(
              width: slot,
              child: Center(
                child: Text(
                  label,
                  style: DgaTypography.textSm.medium.copyWith(
                    color: c.textSecondaryParagraph,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _grid(DgaSemanticColors c, double slot) {
    // Sunday-first grid, matching the Figma header row.
    final blanks = DgaCalendarSystem.leadingBlanks(_month, DateTime.sunday);
    final today = DgaCalendarSystem.dateOnly(DateTime.now());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < _kGridRows; row++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Builder(
                  builder: (context) {
                    final index = row * 7 + col;
                    final day = DateTime(
                      _month.year,
                      _month.month,
                      1 + index - blanks,
                    );
                    final outside = !DgaCalendarSystem.isSameMonth(day, _month);
                    final band = _bandFor(day);
                    return _DayCell(
                      colors: c,
                      day: day,
                      slot: slot,
                      outside: outside,
                      enabled: !outside && _isSelectable(day),
                      isToday: DgaCalendarSystem.isSameDay(day, today),
                      selection: _selectionFor(day),
                      bandLeading: band.leading,
                      bandTrailing: band.trailing,
                      onTap: () => _pickDay(day),
                    );
                  },
                ),
            ],
          ),
      ],
    );
  }

  /// Which halves of the slot the in-range tint covers. Interior days fill
  /// both so consecutive cells join up; endpoints fill only the half facing
  /// the interior. Reading-order (not left/right) so `Row` flips it in RTL.
  ({bool leading, bool trailing}) _bandFor(DateTime day) {
    const none = (leading: false, trailing: false);
    if (!widget.isRange) return none;

    final r = widget.rangeValue;
    if (r == null || !r.isComplete) return none;
    if (r.containsInterior(day)) return (leading: true, trailing: true);

    final d = DgaCalendarSystem.dateOnly(day);
    final start = DgaCalendarSystem.dateOnly(r.start!);
    final end = DgaCalendarSystem.dateOnly(r.end!);
    if (start == end) return none; // single-day range needs no band

    if (d == start) return (leading: false, trailing: true);
    if (d == end) return (leading: true, trailing: false);
    return none;
  }

  _DaySelection _selectionFor(DateTime day) {
    if (!widget.isRange) {
      final v = widget.singleValue;
      if (v != null && DgaCalendarSystem.isSameDay(v, day)) {
        return _DaySelection.endpoint;
      }
      return _DaySelection.none;
    }

    final r = widget.rangeValue;
    if (r == null || r.isEmpty) return _DaySelection.none;
    if (r.isEndpoint(day)) return _DaySelection.endpoint;
    if (r.containsInterior(day)) return _DaySelection.interior;
    return _DaySelection.none;
  }
}

enum _DaySelection { none, endpoint, interior }

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        // 40x40 keeps the tap target at the accessible minimum even though
        // the glyph is 20.
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

/// One day slot: an optional range band filling the full slot width, with the
/// selection circle drawn on top.
class _DayCell extends StatefulWidget {
  const _DayCell({
    required this.colors,
    required this.day,
    required this.slot,
    required this.outside,
    required this.enabled,
    required this.isToday,
    required this.selection,
    required this.bandLeading,
    required this.bandTrailing,
    required this.onTap,
  });

  final DgaSemanticColors colors;
  final DateTime day;
  final double slot;
  final bool outside;
  final bool enabled;
  final bool isToday;
  final _DaySelection selection;
  final bool bandLeading;
  final bool bandTrailing;
  final VoidCallback onTap;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final hovered = widget.enabled && _hovered;
    final pressed = widget.enabled && _pressed;
    final selected = widget.selection == _DaySelection.endpoint;
    final diameter = widget.slot * _kCircleRatio;

    final Color fill;
    if (selected) {
      fill = pressed
          ? c.datecellBackgroundPressed
          : hovered
          ? c.datecellBackgroundHovered
          : c.datecellBackgroundDefault;
    } else if (pressed) {
      fill = c.datecellTodayBackgroundPressed;
    } else if (hovered) {
      fill = c.datecellTodayBackgroundHovered;
    } else {
      fill = c.datecellTodayBackgroundDefault;
    }

    final Color textColor;
    if (selected) {
      textColor = c.textOncolorPrimary;
    } else if (widget.outside || !widget.enabled) {
      textColor = c.textDefaultDisabled;
    } else {
      textColor = c.textDefault;
    }

    final circle = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      width: diameter,
      height: diameter,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        // Today is a ring, not a fill — unless it's also the selection.
        border: widget.isToday && !selected
            ? Border.all(color: c.textPrimarySaFlag, width: 1.5)
            : null,
      ),
      child: Text(
        '${widget.day.day}',
        style:
            (selected
                    ? DgaTypography.textMd.bold
                    : DgaTypography.textMd.regular)
                .copyWith(color: textColor),
      ),
    );

    Widget content = SizedBox(
      width: widget.slot,
      height: widget.slot,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.bandLeading || widget.bandTrailing) _band(c, diameter),
          circle,
        ],
      ),
    );

    if (!widget.enabled) {
      return Semantics(
        label: '${widget.day.day}',
        enabled: false,
        child: content,
      );
    }

    return Semantics(
      button: true,
      selected: selected,
      label: '${widget.day.day}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Listener(
          // Listener, not just MouseRegion, so press registers on touch.
          onPointerDown: (_) => setState(() => _pressed = true),
          onPointerUp: (_) => setState(() => _pressed = false),
          onPointerCancel: (_) => setState(() => _pressed = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: content,
          ),
        ),
      ),
    );
  }

  /// The in-range tint. Drawn across the full slot (not the circle) so
  /// consecutive days join into one continuous band. `Row` flips under RTL,
  /// so leading/trailing are direction-correct for free.
  Widget _band(DgaSemanticColors c, double diameter) {
    const clear = Color(0x00000000);
    return SizedBox(
      height: diameter,
      width: widget.slot,
      child: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: widget.bandLeading ? c.datecellBackground100 : clear,
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: widget.bandTrailing ? c.datecellBackground100 : clear,
            ),
          ),
        ],
      ),
    );
  }
}

/// The year dropdown that overlays the grid when the month label is tapped.
class _YearList extends StatefulWidget {
  const _YearList({
    required this.colors,
    required this.selectedYear,
    required this.firstYear,
    required this.lastYear,
    required this.onPicked,
  });

  final DgaSemanticColors colors;
  final int selectedYear;
  final int firstYear;
  final int lastYear;
  final ValueChanged<int> onPicked;

  @override
  State<_YearList> createState() => _YearListState();
}

class _YearListState extends State<_YearList> {
  static const double _rowHeight = 40;
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    // Open on the current year rather than the start of the century.
    final index = (widget.selectedYear - widget.firstYear).clamp(
      0,
      math.max(0, widget.lastYear - widget.firstYear),
    );
    _scroll = ScrollController(
      initialScrollOffset: math.max(0, (index - 2) * _rowHeight),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final years = [for (var y = widget.firstYear; y <= widget.lastYear; y++) y];

    return Material(
      color: const Color(0x00000000),
      child: Container(
        width: 140,
        height: 280,
        decoration: BoxDecoration(
          color: widget.colors.fieldBackgroundDefault,
          borderRadius: DgaRadius.brSm,
          border: Border.all(color: widget.colors.fieldBorderDefault),
          boxShadow: DgaShadows.lg,
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.symmetric(vertical: DgaSpacing.xs),
          itemCount: years.length,
          itemExtent: _rowHeight,
          itemBuilder: (context, i) => _YearRow(
            colors: widget.colors,
            year: years[i],
            selected: years[i] == widget.selectedYear,
            onTap: () => widget.onPicked(years[i]),
          ),
        ),
      ),
    );
  }
}

class _YearRow extends StatefulWidget {
  const _YearRow({
    required this.colors,
    required this.year,
    required this.selected,
    required this.onTap,
  });

  final DgaSemanticColors colors;
  final int year;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_YearRow> createState() => _YearRowState();
}

class _YearRowState extends State<_YearRow> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;
    final bg = _pressed
        ? c.optionBackgroundPressed
        : _hovered
        ? c.optionBackgroundHover
        : const Color(0x00000000);

    return Semantics(
      button: true,
      selected: widget.selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Listener(
          onPointerDown: (_) => setState(() => _pressed = true),
          onPointerUp: (_) => setState(() => _pressed = false),
          onPointerCancel: (_) => setState(() => _pressed = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            child: Container(
              color: bg,
              padding: const EdgeInsets.symmetric(horizontal: DgaSpacing.xl),
              child: Row(
                children: [
                  Text(
                    '${widget.year}',
                    style: DgaTypography.textMd.regular.copyWith(
                      color: c.textDefault,
                    ),
                  ),
                  const Spacer(),
                  if (widget.selected)
                    Icon(Icons.check, size: 18, color: c.iconDefault),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
