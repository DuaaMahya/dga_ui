import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../calendar/dga_calendar.dart';
import '../calendar/dga_calendar_enums.dart';
import '../text_input/dga_text_input.dart';
import '../text_input/dga_text_input_enums.dart';

/// Gap between the field and the popover, and the minimum margin the popover
/// keeps from every screen edge.
const double _kGap = 6;
const double _kMargin = 8;

/// A date field that opens a [DgaCalendar] in a popover anchored under it.
///
/// Built on [DgaTextInput] rather than re-implementing the field chrome, so
/// the border/fill/hover/press ladder and the center-expanding focus
/// underline all come for free — and the field stays **typeable**: the
/// popover is non-modal, so the keyboard and the calendar coexist.
///
/// Single vs range are named constructors because the value type differs.
class DgaDatePickerInput extends StatefulWidget {
  const DgaDatePickerInput.single({
    super.key,
    DateTime? value,
    required ValueChanged<DateTime?> onChanged,
    this.label,
    this.required = false,
    this.hintText = 'DD/MM/YYYY',
    this.helperText,
    this.errorText,
    this.style = DgaTextInputStyle.standard,
    this.size = DgaTextInputSize.large,
    this.enabled = true,
    this.readOnly = false,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
  }) : isRange = false,
       singleValue = value,
       rangeValue = null,
       onSingleChanged = onChanged,
       onRangeChanged = null;

  const DgaDatePickerInput.range({
    super.key,
    DgaDateRange? value,
    required ValueChanged<DgaDateRange?> onChanged,
    this.label,
    this.required = false,
    this.hintText = 'DD/MM/YYYY – DD/MM/YYYY',
    this.helperText,
    this.errorText,
    this.style = DgaTextInputStyle.standard,
    this.size = DgaTextInputSize.large,
    this.enabled = true,
    this.readOnly = false,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
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

  final String? label;
  final bool required;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final DgaTextInputStyle style;
  final DgaTextInputSize size;
  final bool enabled;
  final bool readOnly;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime day)? selectableDayPredicate;

  bool get _interactive => enabled && !readOnly;

  @override
  State<DgaDatePickerInput> createState() => _DgaDatePickerInputState();
}

class _DgaDatePickerInputState extends State<DgaDatePickerInput> {
  final _overlay = OverlayPortalController();
  final _fieldKey = GlobalKey();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = _formatValue();
  }

  @override
  void didUpdateWidget(covariant DgaDatePickerInput old) {
    super.didUpdateWidget(old);
    if (widget.singleValue != old.singleValue ||
        widget.rangeValue != old.rangeValue) {
      final text = _formatValue();
      // Don't fight the user mid-typing: only rewrite when the value actually
      // renders differently from what's in the box.
      if (text != _controller.text) _controller.text = text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatValue() {
    if (!widget.isRange) return dgaFormatDate(widget.singleValue);
    final r = widget.rangeValue;
    if (r == null || r.start == null) return '';
    if (r.end == null) return dgaFormatDate(r.start);
    return '${dgaFormatDate(r.start)} – ${dgaFormatDate(r.end)}';
  }

  void _open() {
    if (!widget._interactive || _overlay.isShowing) return;
    _overlay.show();
  }

  void _close() {
    if (_overlay.isShowing) _overlay.hide();
  }

  /// Commits typed text only when it parses to a real, selectable date.
  /// Half-typed input is simply ignored rather than raising an error.
  void _onTextChanged(String raw) {
    if (raw.trim().isEmpty) {
      widget.isRange
          ? widget.onRangeChanged!(null)
          : widget.onSingleChanged!(null);
      return;
    }

    if (widget.isRange) {
      final parts = raw
          .split(RegExp(r'[–-]'))
          .where((p) => p.trim().isNotEmpty);
      if (parts.length != 2) return;
      final start = dgaParseDate(parts.first);
      final end = dgaParseDate(parts.last);
      if (start == null || end == null) return;
      if (!_selectable(start) || !_selectable(end)) return;
      widget.onRangeChanged!(
        end.isBefore(start)
            ? DgaDateRange(start: end, end: start)
            : DgaDateRange(start: start, end: end),
      );
      return;
    }

    final parsed = dgaParseDate(raw);
    if (parsed == null || !_selectable(parsed)) return;
    widget.onSingleChanged!(parsed);
  }

  bool _selectable(DateTime d) {
    final day = DgaCalendarSystem.dateOnly(d);
    if (widget.firstDate != null &&
        day.isBefore(DgaCalendarSystem.dateOnly(widget.firstDate!))) {
      return false;
    }
    if (widget.lastDate != null &&
        day.isAfter(DgaCalendarSystem.dateOnly(widget.lastDate!))) {
      return false;
    }
    return widget.selectableDayPredicate?.call(day) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: _buildOverlay,
      child: KeyedSubtree(
        key: _fieldKey,
        child: DgaTextInput(
          controller: _controller,
          focusNode: _focusNode,
          label: widget.label,
          required: widget.required,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          style: widget.style,
          size: widget.size,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          clearable: true,
          keyboardType: TextInputType.datetime,
          onTap: _open,
          onChanged: (v) {
            _onTextChanged(v);
            _open();
          },
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    // Measure the field the same way DgaTooltip does — a GlobalKey lookup is
    // recomputed on every overlay rebuild and needs no LayerLink plumbing.
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return const SizedBox.shrink();
    final targetRect = box.localToGlobal(Offset.zero) & box.size;

    return Stack(
      children: [
        // Tap-away barrier.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _close,
          ),
        ),
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _PopoverLayoutDelegate(targetRect),
            child: widget.isRange
                ? DgaCalendar.range(
                    value: widget.rangeValue,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    onChanged: (r) {
                      widget.onRangeChanged!(r);
                      // Only dismiss once both ends are picked.
                      if (r != null && r.isComplete) _close();
                    },
                  )
                : DgaCalendar.single(
                    value: widget.singleValue,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    selectableDayPredicate: widget.selectableDayPredicate,
                    onChanged: (d) {
                      widget.onSingleChanged!(d);
                      _close();
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class _PopoverLayoutDelegate extends SingleChildLayoutDelegate {
  _PopoverLayoutDelegate(this.targetRect);

  final Rect targetRect;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: math.max(0, constraints.maxWidth - _kMargin * 2),
      maxHeight: math.max(0, constraints.maxHeight - _kMargin * 2),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Prefer below the field; flip above when there isn't room.
    final below = targetRect.bottom + _kGap;
    final above = targetRect.top - childSize.height - _kGap;
    final fitsBelow = below + childSize.height + _kMargin <= size.height;
    var y = fitsBelow ? below : above;

    // Start-aligned with the field, then clamped so it never leaves the
    // screen — the calendar is wider than most fields.
    var x = targetRect.left;

    x = x.clamp(
      _kMargin,
      math.max(_kMargin, size.width - childSize.width - _kMargin),
    );
    y = y.clamp(
      _kMargin,
      math.max(_kMargin, size.height - childSize.height - _kMargin),
    );
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopoverLayoutDelegate old) =>
      old.targetRect != targetRect;
}

/// Renders a date as `dd/MM/yyyy`. Returns `''` for null.
String dgaFormatDate(DateTime? d) {
  if (d == null) return '';
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year.toString().padLeft(4, '0')}';
}

/// Parses `d/M/yy` or `d/M/yyyy` with `/`, `-` or `.` separators.
///
/// Returns null for anything that isn't a real calendar date, so half-typed
/// input never commits. Two-digit years resolve to 2000+; four-digit years
/// are taken literally.
DateTime? dgaParseDate(String raw) {
  final parts = raw
      .trim()
      .split(RegExp(r'[/.\-]'))
      .where((p) => p.trim().isNotEmpty)
      .toList();
  if (parts.length != 3) return null;

  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  var year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  if (parts[2].trim().length <= 2) year += 2000;

  if (month < 1 || month > 12 || day < 1) return null;
  final candidate = DateTime(year, month, day);
  // Rejects overflow like 31/02 — DateTime would silently roll it forward.
  if (candidate.day != day ||
      candidate.month != month ||
      candidate.year != year) {
    return null;
  }
  return candidate;
}
