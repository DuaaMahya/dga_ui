import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import '../text_input/dga_text_input_enums.dart';

/// Multi-line text field. Shares the DGA text-input chrome (fill/border by
/// [DgaTextInputStyle], `input*` tokens) and the center-expand focus
/// underline, but grows vertically.
class DgaTextarea extends StatefulWidget {
  const DgaTextarea({
    super.key,
    this.controller,
    this.label,
    this.required = false,
    this.hintText,
    this.helperText,
    this.errorText,
    this.style = DgaTextInputStyle.standard,
    this.enabled = true,
    this.readOnly = false,
    this.minLines = 3,
    this.maxLines = 6,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final bool required;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final DgaTextInputStyle style;
  final bool enabled;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _hasError => errorText != null;

  @override
  State<DgaTextarea> createState() => _DgaTextareaState();
}

class _DgaTextareaState extends State<DgaTextarea>
    with SingleTickerProviderStateMixin {
  late final AnimationController _underline;
  FocusNode? _internal;
  FocusNode get _focusNode => widget.focusNode ?? (_internal ??= FocusNode());
  bool _focused = false;
  bool _pressed = false;
  bool _hovered = false;

  bool get _interactive => widget.enabled && !widget.readOnly;

  /// Pointer-down shows a short centred stub; focus then carries it out to
  /// full width from wherever the stub got to.
  void _onPointerDown() {
    // Press is only a stepping stone into focus — see DgaTextInput.
    if (_focusNode.hasFocus) return;
    setState(() => _pressed = true);
    _underline.animateTo(
      kDgaFieldPressStub,
      duration: kDgaFieldPressDuration,
      curve: Curves.easeOut,
    );
  }

  void _onPointerRelease() {
    setState(() => _pressed = false);
    if (!_focusNode.hasFocus) _underline.animateBack(0, curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    _underline = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _focusNode.addListener(_onFocus);
  }

  void _onFocus() {
    final f = _focusNode.hasFocus;
    if (f == _focused) return;
    setState(() => _focused = f);
    f
        ? _underline.animateTo(1, curve: Curves.easeOut)
        : _underline.animateBack(0, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);
    _internal?.dispose();
    _underline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;
    final fill = !widget.enabled
        ? c.backgroundDisabled
        : (_pressed && _interactive)
        ? c.fieldBackgroundPressed
        : switch (widget.style) {
            DgaTextInputStyle.standard => c.fieldBackgroundDefault,
            DgaTextInputStyle.filledDarker => c.fieldBackgroundDarker,
            DgaTextInputStyle.filledLighter => c.fieldBackgroundLighter,
          };
    // Press keeps the light stroke — the feedback is the stub + fill.
    final borderColor = widget._hasError
        ? c.fieldBorderError
        : (_hovered && _interactive && !_pressed)
        ? c.fieldBorderHovered
        : (widget.style == DgaTextInputStyle.standard
              ? c.fieldBorderDefault
              : null);
    final underlineColor = widget._hasError
        ? c.fieldBorderError
        : c.fieldBorderPressed;
    final textColor = !widget.enabled
        ? c.textDefaultDisabled
        : (_focused ? c.fieldTextFocused : c.fieldTextFilled);

    final field = Stack(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Listener(
            onPointerDown: _interactive ? (_) => _onPointerDown() : null,
            onPointerUp: _interactive ? (_) => _onPointerRelease() : null,
            onPointerCancel: _interactive ? (_) => _onPointerRelease() : null,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: DgaRadius.brSm,
                border: borderColor != null
                    ? Border.all(color: borderColor)
                    : null,
                boxShadow: _focused && widget.enabled ? DgaShadows.md : null,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: DgaSpacing.lg,
                vertical: DgaSpacing.md,
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
                cursorColor: c.fieldBorderPressed,
                style: DgaTypography.textMd.regular.copyWith(color: textColor),
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                  hintStyle: DgaTypography.textMd.regular.copyWith(
                    color: c.fieldTextPlaceholder,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: _underline,
            builder: (context, _) => Transform.scale(
              scaleX: _underline.value,
              alignment: Alignment.center,
              child: Container(height: 2, color: underlineColor),
            ),
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.required) ...[
                Text(
                  '*',
                  style: DgaTypography.textSm.regular.copyWith(
                    color: c.fieldBorderError,
                  ),
                ),
                const SizedBox(width: DgaSpacing.xs),
              ],
              Text(
                widget.label!,
                style: DgaTypography.textSm.regular.copyWith(
                  color: c.fieldTextLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: DgaSpacing.md),
        ],
        field,
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: DgaSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget._hasError ? Icons.error_outline : Icons.help_outline,
                size: 16,
                color: widget._hasError
                    ? c.fieldBorderError
                    : c.fieldTextHelper,
              ),
              const SizedBox(width: DgaSpacing.md),
              Flexible(
                child: Text(
                  widget.errorText ?? widget.helperText!,
                  style: DgaTypography.textSm.regular.copyWith(
                    color: widget._hasError
                        ? c.fieldBorderError
                        : c.fieldTextHelper,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
