import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../theme/dga_semantic_colors.dart';

/// Library-private enum backing the six public factories on `DgaButton`.
///
/// Callers pick a style via `DgaButton.primary(...)` etc. and never see this
/// enum. Kept in a separate file so the token-resolver logic stays testable
/// in isolation.
enum DgaButtonStyle {
  primary,
  neutral,
  secondarySolid,
  secondaryOutline,
  subtle,
  transparent,
}

enum DgaButtonInteractionState {
  defaultState,
  hovered,
  pressed,
  focused,
  selected,
  disabled,
}

@immutable
class DgaButtonPaint {
  const DgaButtonPaint({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Color? border;
}

const Color _transparent = Color(0x00000000);

/// Resolves the (background, foreground, border) triplet for a given
/// combination of style/state/destructive/on-color, reading tokens from the
/// mode-appropriate [DgaSemanticColors] passed in by the widget.
DgaButtonPaint resolveButtonPaint({
  required DgaSemanticColors colors,
  required DgaButtonStyle style,
  required DgaButtonInteractionState state,
  required bool destructive,
  required bool onColor,
}) {
  if (state == DgaButtonInteractionState.disabled) {
    return DgaButtonPaint(
      background: onColor
          ? colors.buttonBackgroundDisabledOnColor
          : colors.backgroundDisabled,
      foreground: onColor
          ? colors.textDefaultOncolorDisabled
          : colors.textDefaultDisabled,
      border: onColor ? colors.borderWhite40 : colors.borderNeutralSecondary,
    );
  }

  if (destructive) return _resolveDestructive(colors, style, state, onColor);
  if (onColor) return _resolveOnColor(colors, style, state);
  return _resolveDefault(colors, style, state);
}

DgaButtonPaint _resolveDefault(
  DgaSemanticColors c,
  DgaButtonStyle style,
  DgaButtonInteractionState state,
) {
  switch (style) {
    case DgaButtonStyle.primary:
      return DgaButtonPaint(
        background: switch (state) {
          DgaButtonInteractionState.defaultState =>
            c.buttonBackgroundPrimaryDefault,
          DgaButtonInteractionState.hovered => c.buttonBackgroundPrimaryHovered,
          DgaButtonInteractionState.pressed => c.buttonBackgroundPrimaryPressed,
          DgaButtonInteractionState.focused => c.buttonBackgroundPrimaryFocused,
          DgaButtonInteractionState.selected =>
            c.buttonBackgroundPrimarySelected,
          DgaButtonInteractionState.disabled => c.backgroundDisabled,
        },
        foreground: c.textOncolorPrimary,
      );

    case DgaButtonStyle.neutral:
      // Strong dark-fill CTA — Figma's `button-background-black-*` tokens
      // stay the same dark fill in both light and dark mode, so the label is
      // always the on-color (white) text token.
      return DgaButtonPaint(
        background: switch (state) {
          DgaButtonInteractionState.defaultState =>
            c.buttonBackgroundBlackDefault,
          DgaButtonInteractionState.hovered => c.buttonBackgroundBlackHovered,
          DgaButtonInteractionState.pressed => c.buttonBackgroundBlackPressed,
          DgaButtonInteractionState.focused => c.buttonBackgroundBlackFocused,
          DgaButtonInteractionState.selected => c.buttonBackgroundBlackSelected,
          DgaButtonInteractionState.disabled => c.backgroundDisabled,
        },
        foreground: c.textOncolorPrimary,
      );

    case DgaButtonStyle.secondarySolid:
      // Soft light-fill button — fill only, no border (per Figma). Backed by
      // the `button-background-neutral-*` tokens.
      return DgaButtonPaint(
        background: switch (state) {
          DgaButtonInteractionState.defaultState =>
            c.buttonBackgroundNeutralDefault,
          DgaButtonInteractionState.hovered => c.buttonBackgroundNeutralHovered,
          DgaButtonInteractionState.pressed => c.buttonBackgroundNeutralPressed,
          DgaButtonInteractionState.focused => c.buttonBackgroundNeutralFocused,
          DgaButtonInteractionState.selected =>
            c.buttonBackgroundNeutralSelected,
          DgaButtonInteractionState.disabled => c.backgroundDisabled,
        },
        foreground: c.textDefault,
      );

    case DgaButtonStyle.secondaryOutline:
      // Light-wash press/hover states — use the Neutral family fill tokens.
      return DgaButtonPaint(
        background: switch (state) {
          DgaButtonInteractionState.pressed => c.buttonBackgroundNeutralPressed,
          DgaButtonInteractionState.hovered => c.buttonBackgroundNeutralHovered,
          DgaButtonInteractionState.selected =>
            c.buttonBackgroundNeutralSelected,
          _ => _transparent,
        },
        foreground: c.textDefault,
        border: c.borderNeutralPrimary,
      );

    case DgaButtonStyle.subtle:
      return DgaButtonPaint(
        background: switch (state) {
          DgaButtonInteractionState.hovered => c.buttonBackgroundNeutralHovered,
          DgaButtonInteractionState.pressed => c.buttonBackgroundNeutralPressed,
          DgaButtonInteractionState.selected =>
            c.buttonBackgroundNeutralSelected,
          _ => _transparent,
        },
        foreground: c.textDefault,
      );

    case DgaButtonStyle.transparent:
      // Link-style: background stays transparent in every state; only the
      // label/icon color shifts, using the brand-green link tokens.
      return DgaButtonPaint(
        background: _transparent,
        foreground: switch (state) {
          DgaButtonInteractionState.hovered => c.linkPrimaryHovered,
          DgaButtonInteractionState.pressed => c.linkPrimaryPressed,
          DgaButtonInteractionState.selected => c.linkPrimaryHovered,
          _ => c.textDefault,
        },
      );
  }
}

DgaButtonPaint _resolveOnColor(
  DgaSemanticColors c,
  DgaButtonStyle style,
  DgaButtonInteractionState state,
) {
  final onColorBg = switch (state) {
    DgaButtonInteractionState.defaultState => c.buttonBackgroundOncolorDefault,
    DgaButtonInteractionState.hovered => c.buttonBackgroundOncolorHovered,
    DgaButtonInteractionState.pressed => c.buttonBackgroundOncolorPressed,
    DgaButtonInteractionState.focused => c.buttonBackgroundOncolorFocused,
    DgaButtonInteractionState.selected => c.buttonBackgroundOncolorSelected,
    DgaButtonInteractionState.disabled => c.buttonBackgroundDisabledOnColor,
  };

  switch (style) {
    case DgaButtonStyle.transparent:
      // Link-style on-color: transparent bg in every state; label shifts
      // between white and the on-color transparent-label tokens.
      return DgaButtonPaint(
        background: _transparent,
        foreground: switch (state) {
          DgaButtonInteractionState.hovered =>
            c.buttonLabelTransparentHoveredOnColor,
          DgaButtonInteractionState.pressed =>
            c.buttonLabelTransparentPressedOnColor,
          DgaButtonInteractionState.selected =>
            c.buttonLabelTransparentSelectedOnColor,
          _ => c.textOncolorPrimary,
        },
      );
    case DgaButtonStyle.secondaryOutline:
      return DgaButtonPaint(
        background: _transparent,
        foreground: c.textOncolorPrimary,
        border: c.borderWhite40,
      );
    default:
      return DgaButtonPaint(background: onColorBg, foreground: c.textDefault);
  }
}

DgaButtonPaint _resolveDestructive(
  DgaSemanticColors c,
  DgaButtonStyle style,
  DgaButtonInteractionState state,
  bool onColor,
) {
  // Strong-fill styles get the solid-red danger palette; light/outline/
  // subtle styles get the red-wash palette.
  final isSolidRed =
      style == DgaButtonStyle.primary || style == DgaButtonStyle.neutral;

  if (isSolidRed) {
    return DgaButtonPaint(
      background: switch (state) {
        DgaButtonInteractionState.defaultState =>
          c.buttonBackgroundDangerPrimaryDefault,
        DgaButtonInteractionState.hovered =>
          c.buttonBackgroundDangerPrimaryHovered,
        DgaButtonInteractionState.pressed =>
          c.buttonBackgroundDangerPrimaryPressed,
        DgaButtonInteractionState.focused =>
          c.buttonBackgroundDangerPrimaryFocused,
        DgaButtonInteractionState.selected =>
          c.buttonBackgroundDangerPrimarySelected,
        DgaButtonInteractionState.disabled => c.backgroundDisabled,
      },
      foreground: onColor
          ? c.buttonLabelDangerPrimaryDefaultOncolor
          : c.textOncolorPrimary,
    );
  }

  return DgaButtonPaint(
    background: switch (state) {
      DgaButtonInteractionState.defaultState =>
        c.buttonBackgroundDangerSecondaryDefault,
      DgaButtonInteractionState.hovered =>
        c.buttonBackgroundDangerSecondaryHovered,
      DgaButtonInteractionState.pressed =>
        c.buttonBackgroundDangerSecondaryPressed,
      DgaButtonInteractionState.focused =>
        c.buttonBackgroundDangerSecondaryFocused,
      DgaButtonInteractionState.selected =>
        c.buttonBackgroundDangerSecondarySelected,
      DgaButtonInteractionState.disabled => c.backgroundDisabled,
    },
    foreground: c.textError,
    border: c.borderErrorLight,
  );
}
