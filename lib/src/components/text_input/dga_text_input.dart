import 'package:flutter/material.dart';

import '../../theme/dga_radius.dart';
import '../../theme/dga_semantic_colors.dart';
import '../../theme/dga_shadows.dart';
import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';
import 'dga_text_input_enums.dart';

/// DGA text input.
///
/// Signature interaction: a 2px underline that **expands from the center**
/// outward when the field gains focus (after the tap), and retracts to the
/// center on blur — mirroring the Figma "Thin underline" element.
class DgaTextInput extends StatefulWidget {
  const DgaTextInput({
    super.key,
    this.controller,
    this.label,
    this.required = false,
    this.hintText,
    this.helperText,
    this.errorText,
    this.leadingIcon,
    this.prefix,
    this.suffix,
    this.clearable = true,
    this.size = DgaTextInputSize.large,
    this.style = DgaTextInputStyle.standard,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? label;
  final bool required;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? leadingIcon;
  final Widget? prefix;
  final Widget? suffix;

  /// Shows an inline "×" once there's text, positioned before [suffix].
  /// Tapping it empties the field and re-fires [onChanged] with `''`.
  final bool clearable;
  final DgaTextInputSize size;
  final DgaTextInputStyle style;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Fires when the text area is tapped. Lets a wrapper open a popover (see
  /// `DgaDatePickerInput`) without giving up the field's own editability.
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _hasError => errorText != null;

  @override
  State<DgaTextInput> createState() => _DgaTextInputState();
}

class _DgaTextInputState extends State<DgaTextInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _underline;
  FocusNode? _internalFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  TextEditingController? _internalController;
  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController());

  bool _focused = false;
  bool _pressed = false;
  bool _hovered = false;

  bool get _interactive => widget.enabled && !widget.readOnly;

  /// Pointer-down shows a short centred stub; focus then carries it out to
  /// full width from wherever the stub got to.
  void _onPointerDown() {
    // Press is only a stepping stone into focus. Once the field already has
    // focus, re-pressing it must stay in the focus state rather than yanking
    // the full-width underline back to the stub.
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
    // A tap normally lands focus, which expands the stub. If it didn't
    // (tap cancelled, or focus refused), retract it.
    if (!_focusNode.hasFocus) _underline.animateBack(0, curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    _underline = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _focusNode.addListener(_onFocusChange);
    if (widget.clearable) _controller.addListener(_onTextChange);
  }

  @override
  void didUpdateWidget(covariant DgaTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _internalFocusNode?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
    if (widget.clearable != oldWidget.clearable ||
        widget.controller != oldWidget.controller) {
      if (oldWidget.clearable) {
        (oldWidget.controller ?? _internalController)?.removeListener(
          _onTextChange,
        );
      }
      if (widget.clearable) _controller.addListener(_onTextChange);
    }
  }

  // The clear button's visibility depends on `_controller.text`, which isn't
  // otherwise observed by this widget — TextField manages it internally.
  void _onTextChange() => setState(() {});

  void _onFocusChange() {
    final focused = _focusNode.hasFocus;
    if (focused == _focused) return;
    setState(() => _focused = focused);
    // Underline grows from center on focus, retracts on blur.
    if (focused) {
      _underline.animateTo(1, curve: Curves.easeOut);
    } else {
      _underline.animateBack(0, curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _internalFocusNode?.dispose();
    if (widget.clearable) _controller.removeListener(_onTextChange);
    _internalController?.dispose();
    _underline.dispose();
    super.dispose();
  }

  Color _fill(DgaSemanticColors c) {
    if (!widget.enabled) return c.backgroundDisabled;
    if (_pressed && _interactive) return c.fieldBackgroundPressed;
    return switch (widget.style) {
      DgaTextInputStyle.standard => c.fieldBackgroundDefault,
      DgaTextInputStyle.filledDarker => c.fieldBackgroundDarker,
      DgaTextInputStyle.filledLighter => c.fieldBackgroundLighter,
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = DgaTheme.of(context).colors;

    // Border color:
    //  - error → red
    //  - hovered → darker stroke
    //  - standard style → default neutral stroke
    //  - filled styles → NO stroke in default state (fill carries the shape)
    //
    // Press deliberately does NOT darken the border: per spec the box keeps
    // its light stroke and the press feedback is the underline stub + fill.
    final Color? borderColor;
    if (widget._hasError) {
      borderColor = c.fieldBorderError;
    } else if (_hovered && _interactive && !_pressed) {
      borderColor = c.fieldBorderHovered;
    } else if (widget.style == DgaTextInputStyle.standard) {
      borderColor = c.fieldBorderDefault;
    } else {
      borderColor = null;
    }

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
            // The TextField is only as tall as one text line, so without this
            // the field box has a dead band above and below it where taps
            // neither focus nor fire onTap. The inner TextField wins the
            // gesture arena wherever it sits, so this only handles the gap.
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _interactive
                  ? () {
                      _focusNode.requestFocus();
                      widget.onTap?.call();
                    }
                  : null,
              child: Container(
                height: widget.size.fieldHeight,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: _fill(c),
                  borderRadius: DgaRadius.brSm,
                  border: borderColor != null
                      ? Border.all(color: borderColor, width: 1)
                      : null,
                  boxShadow: _focused && widget.enabled ? DgaShadows.md : null,
                ),
                child: Row(
                  children: [
                    if (widget.prefix != null)
                      _affix(c, widget.prefix!, isPrefix: true),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: DgaSpacing.md,
                          end: DgaSpacing.xl,
                        ),
                        child: Row(
                          children: [
                            if (widget.leadingIcon != null) ...[
                              IconTheme.merge(
                                data: IconThemeData(color: textColor, size: 20),
                                child: widget.leadingIcon!,
                              ),
                              const SizedBox(width: DgaSpacing.md),
                            ],
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                enabled: widget.enabled,
                                readOnly: widget.readOnly,
                                autofocus: widget.autofocus,
                                obscureText: widget.obscureText,
                                keyboardType: widget.keyboardType,
                                maxLines: widget.obscureText
                                    ? 1
                                    : widget.maxLines,
                                onChanged: widget.onChanged,
                                onSubmitted: widget.onSubmitted,
                                onTap: widget.onTap,
                                cursorColor: c.fieldBorderPressed,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                                style: DgaTypography.textMd.regular.copyWith(
                                  color: textColor,
                                ),
                                decoration: InputDecoration.collapsed(
                                  hintText: widget.hintText,
                                  hintStyle: DgaTypography.textMd.regular
                                      .copyWith(color: c.fieldTextPlaceholder),
                                ).copyWith(isDense: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_clearButton(c) case final clear?) clear,
                    if (widget.suffix != null)
                      _affix(c, widget.suffix!, isPrefix: false),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Press shows a short centred stub; focus expands it to full width.
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
          _buildLabel(c),
          const SizedBox(height: DgaSpacing.md),
        ],
        field,
        if (widget.errorText != null || widget.helperText != null) ...[
          const SizedBox(height: DgaSpacing.xs),
          _buildHelper(c),
        ],
      ],
    );
  }

  Widget? _clearButton(DgaSemanticColors c) {
    if (!widget.clearable || !_interactive || _controller.text.isEmpty) {
      return null;
    }
    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: widget.suffix != null ? DgaSpacing.md : DgaSpacing.xl,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
        child: Icon(Icons.close_rounded, size: 20, color: c.iconDefault),
      ),
    );
  }

  Widget _affix(DgaSemanticColors c, Widget child, {required bool isPrefix}) {
    // Round the outer corners so the affix follows the container radius
    // instead of poking square corners past it. Directional so it flips
    // correctly under RTL.
    const r = Radius.circular(DgaRadius.sm);
    final radius = isPrefix
        ? const BorderRadiusDirectional.only(topStart: r, bottomStart: r)
        : const BorderRadiusDirectional.only(topEnd: r, bottomEnd: r);
    return Container(
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: DgaSpacing.xl,
        vertical: DgaSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: c.fieldBackgroundDarker,
        borderRadius: radius,
      ),
      child: DefaultTextStyle.merge(
        style: DgaTypography.textMd.regular.copyWith(
          color: c.fieldTextPlaceholder,
        ),
        child: child,
      ),
    );
  }

  Widget _buildLabel(DgaSemanticColors c) => Row(
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
        style: DgaTypography.textSm.regular.copyWith(color: c.fieldTextLabel),
      ),
    ],
  );

  Widget _buildHelper(DgaSemanticColors c) {
    final isError = widget._hasError;
    final text = widget.errorText ?? widget.helperText!;
    final color = isError ? c.fieldBorderError : c.fieldTextHelper;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.help_outline,
          size: 16,
          color: color,
        ),
        const SizedBox(width: DgaSpacing.md),
        Flexible(
          child: Text(
            text,
            style: DgaTypography.textSm.regular.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
