import 'package:flutter/foundation.dart';

/// A start/end date pair for [DgaCalendar.range].
///
/// Both ends are nullable because a range is picked in two taps — after the
/// first tap only [start] is known. Flutter's own `DateTimeRange` requires
/// both ends, so it can't represent that half-picked state.
@immutable
class DgaDateRange {
  const DgaDateRange({this.start, this.end});

  final DateTime? start;
  final DateTime? end;

  bool get isComplete => start != null && end != null;
  bool get isEmpty => start == null && end == null;

  /// True when [day] falls strictly between the two ends — the cells that get
  /// the light in-range band rather than a solid endpoint fill.
  bool containsInterior(DateTime day) {
    if (!isComplete) return false;
    final d = DgaCalendarSystem.dateOnly(day);
    return d.isAfter(DgaCalendarSystem.dateOnly(start!)) &&
        d.isBefore(DgaCalendarSystem.dateOnly(end!));
  }

  bool isEndpoint(DateTime day) {
    final d = DgaCalendarSystem.dateOnly(day);
    return (start != null && d == DgaCalendarSystem.dateOnly(start!)) ||
        (end != null && d == DgaCalendarSystem.dateOnly(end!));
  }

  DgaDateRange copyWith({DateTime? start, DateTime? end}) =>
      DgaDateRange(start: start ?? this.start, end: end ?? this.end);

  @override
  bool operator ==(Object other) =>
      other is DgaDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DgaDateRange($start – $end)';
}

/// All calendar-arithmetic and month/weekday naming lives behind this seam.
///
/// Only the Gregorian implementation ships today. Hijri (Umm al-Qura) can be
/// added later as a second implementation without changing any widget API —
/// which is why nothing outside this class does date math directly.
abstract final class DgaCalendarSystem {
  const DgaCalendarSystem._();

  /// Strips the time component so two DateTimes on the same calendar day
  /// compare equal. Every date comparison in the calendar goes through this.
  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime firstDayOfMonth(DateTime month) =>
      DateTime(month.year, month.month);

  static int daysInMonth(DateTime month) =>
      DateTime(month.year, month.month + 1, 0).day;

  /// How many leading blanks the grid needs before day 1, given a grid whose
  /// first column is [firstWeekday] (1 = Monday … 7 = Sunday, per DateTime).
  static int leadingBlanks(DateTime month, int firstWeekday) {
    final weekdayOfFirst = firstDayOfMonth(month).weekday;
    return (weekdayOfFirst - firstWeekday + 7) % 7;
  }

  static DateTime addMonths(DateTime month, int delta) =>
      DateTime(month.year, month.month + delta);

  static bool isSameDay(DateTime a, DateTime b) => dateOnly(a) == dateOnly(b);

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// Gregorian month names. A localized build can swap these wholesale.
  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Two-letter weekday abbreviations, indexed Sunday-first to match the
  /// Figma header row (Su Mo Tu We Th Fr Sa).
  static const List<String> weekdayAbbreviations = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  static String monthLabel(DateTime month) =>
      '${monthNames[month.month - 1]} ${month.year}';
}
