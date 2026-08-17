import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _single = DateTime.now();
  DgaDateRange? _range;
  DateTime? _bounded;
  DateTime? _weekdaysOnly;

  static final _today = DateTime.now();

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaCalendar',
    children: [
      sectionHeader(context, 'Single — tap a day'),
      sectionRow(
        DgaCalendar.single(
          value: _single,
          onChanged: (d) => setState(() => _single = d),
        ),
      ),
      sectionRow(_caption(context, 'Selected: ${_fmt(_single)}')),

      sectionHeader(context, 'Range — tap a start, then an end'),
      sectionRow(
        DgaCalendar.range(
          value: _range,
          onChanged: (r) => setState(() => _range = r),
        ),
      ),
      sectionRow(
        _caption(
          context,
          _range == null
              ? 'No range selected'
              : '${_fmt(_range!.start)} → ${_fmt(_range!.end)}',
        ),
      ),

      sectionHeader(context, 'Bounded — only this month is selectable'),
      sectionRow(
        DgaCalendar.single(
          value: _bounded,
          firstDate: DateTime(_today.year, _today.month, 1),
          lastDate: DateTime(_today.year, _today.month + 1, 0),
          onChanged: (d) => setState(() => _bounded = d),
        ),
      ),

      sectionHeader(context, 'Weekdays only — Fri/Sat vetoed by predicate'),
      sectionRow(
        DgaCalendar.single(
          value: _weekdaysOnly,
          selectableDayPredicate: (d) =>
              d.weekday != DateTime.friday && d.weekday != DateTime.saturday,
          onChanged: (d) => setState(() => _weekdaysOnly = d),
        ),
      ),
    ],
  );

  static String _fmt(DateTime? d) =>
      d == null ? '—' : '${d.day}/${d.month}/${d.year}';

  Widget _caption(BuildContext context, String text) => Text(
    text,
    style: DgaTypography.textSm.regular.copyWith(
      color: DgaTheme.of(context).colors.textSecondaryParagraph,
    ),
  );
}
