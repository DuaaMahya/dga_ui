import 'package:flutter/painting.dart';

import 'dga_primitives.dart';

/// Semantic (theme) color tokens.
///
/// Sourced 1:1 from the official DGA `Themes.Light.tokens.json` /
/// `Themes.Dark.tokens.json` exports — one getter per token, 361 total,
/// grouped into the same 17 sections as the JSON source (Background, Text,
/// Global, Border, Button, Chip, Link, Icon, Tag, Form, Controls, Table,
/// Stepper, Tooltip, Charts, Progress Bar, Alpha). Getter names camelCase the
/// official token name verbatim (including source quirks, e.g.
/// `chipBackgroundOnColorDiabled`, `tableBoarderRowSelectedHovered`) so the
/// mapping back to Figma stays traceable for future syncs.
///
/// Two token names collide across sections (`border-disabled` appears in
/// both `Global` and `Border`; `control-disabled` in both `Global` and
/// `Controls`) — the `Global`-section ones are prefixed: [globalBorderDisabled],
/// [globalControlDisabled].
///
/// Primitives never appear in a component; they only appear as the
/// right-hand side of a getter on one of the two impls below.
abstract class DgaSemanticColors {
  const DgaSemanticColors();
  const factory DgaSemanticColors.light() = _DgaSemanticColorsLight;
  const factory DgaSemanticColors.dark() = _DgaSemanticColorsDark;

  // ── Background ──────────────────────────────────────────────────
  Color get backgroundWhite;
  Color get backgroundBody;
  Color get backgroundMenu;
  Color get backgroundCard;
  Color get surfaceOncolor;
  Color get backgroundBlack;
  Color get backgroundNeutral800;
  Color get backgroundNeutral400;
  Color get backgroundNeutral300;
  Color get backgroundNeutral200;
  Color get backgroundNeutral100;
  Color get backgroundNeutral50;
  Color get backgroundNeutral25;
  Color get backgroundPrimary;
  Color get backgroundPrimary400;
  Color get backgroundPrimary200;
  Color get backgroundPrimary50;
  Color get backgroundPrimary25;
  Color get backgroundSecondary50;
  Color get backgroundSecondary25;
  Color get backgroundTertiary50;
  Color get backgroundTertiary25;
  Color get backgroundSuccess;
  Color get backgroundSuccess50;
  Color get backgroundSuccess25;
  Color get backgroundInfo;
  Color get backgroundInfo50;
  Color get backgroundInfo25;
  Color get backgroundWarning;
  Color get backgroundWarning50;
  Color get backgroundWarning25;
  Color get backgroundError;
  Color get backgroundError50;
  Color get backgroundError25;
  Color get backgroundSaFlag;
  Color get backgroundSaFlag50;
  Color get backgroundSaFlag25;
  Color get backgroundNotificationWhite;
  Color get backgroundNavHeader;

  // ── Text ────────────────────────────────────────────────────────
  Color get textDefault;
  Color get textWhite; //Added Manually
  Color get textPrimary;
  Color get textPrimarySaFlag;
  Color get textDisplay;
  Color get textPrimaryParagraph;
  Color get textSecondaryParagraph;
  Color get textOncolorPrimary;
  Color get textOncolorSecondary;
  Color get textOncolorTertiary;
  Color get textSuccess;
  Color get textInfo;
  Color get textWarning;
  Color get textError;
  Color get textPrimaryLight;

  // ── Global ──────────────────────────────────────────────────────
  Color get textDefaultDisabled;
  Color get textDefaultOncolorDisabled;
  Color get globalBorderDisabled;
  Color get backgroundDisabled;
  Color get backgroundDisabledPrimary;
  Color get backgroundInverseDisabled;
  Color get iconDefaultDisabled;
  Color get iconDefaultOncolorDisabled;
  Color get globalControlDisabled;

  // ── Border ──────────────────────────────────────────────────────
  Color get borderWhite;
  Color get borderWhite40;
  Color get borderBlack;
  Color get borderPrimary;
  Color get borderPrimaryLight;
  Color get borderNeutralPrimary;
  Color get borderNeutralSecondary;
  Color get borderNeutralTertiary;
  Color get borderBackgroundWhite;
  Color get borderBackgroundNeutral;
  Color get borderTransparent10;
  Color get borderOncolorTransparent30;
  Color get borderSuccess;
  Color get borderSuccessLight;
  Color get borderInfo;
  Color get borderInfoLight;
  Color get borderWarning;
  Color get borderWarningLight;
  Color get borderError;
  Color get borderErrorLight;
  Color get borderDisabled;

  // ── Button ──────────────────────────────────────────────────────
  Color get buttonBackgroundBlackDefault;
  Color get buttonBackgroundBlackHovered;
  Color get buttonBackgroundBlackPressed;
  Color get buttonBackgroundBlackSelected;
  Color get buttonBackgroundBlackFocused;
  Color get buttonBackgroundPrimaryDefault;
  Color get buttonBackgroundPrimaryHovered;
  Color get buttonBackgroundPrimaryPressed;
  Color get buttonBackgroundPrimarySelected;
  Color get buttonBackgroundPrimaryFocused;
  Color get buttonBackgroundNeutralDefault;
  Color get buttonBackgroundNeutralHovered;
  Color get buttonBackgroundNeutralPressed;
  Color get buttonBackgroundNeutralSelected;
  Color get buttonBackgroundNeutralFocused;
  Color get buttonBackgroundDangerPrimaryDefault;
  Color get buttonBackgroundDangerPrimaryHovered;
  Color get buttonBackgroundDangerPrimaryPressed;
  Color get buttonBackgroundDangerPrimarySelected;
  Color get buttonBackgroundDangerPrimaryFocused;
  Color get buttonLabelDangerPrimaryDefaultOncolor;
  Color get buttonLabelDangerPrimaryHoveredOncolor;
  Color get buttonLabelDangerPrimaryPressedOncolor;
  Color get buttonBackgroundDangerSecondaryDefault;
  Color get buttonBackgroundDangerSecondaryHovered;
  Color get buttonBackgroundDangerSecondaryPressed;
  Color get buttonBackgroundDangerSecondarySelected;
  Color get buttonBackgroundDangerSecondaryFocused;
  Color get buttonBackgroundOncolorDefault;
  Color get buttonBackgroundOncolorHovered;
  Color get buttonBackgroundOncolorPressed;
  Color get buttonBackgroundOncolorSelected;
  Color get buttonBackgroundOncolorFocused;
  Color get buttonBackgroundTransparentDefault;
  Color get buttonBackgroundTransparentHovered;
  Color get buttonBackgroundTransparentPressed;
  Color get buttonBackgroundTransparentSelected;
  Color get buttonBackgroundTransparentFocused;
  Color get buttonBackgroundDisabledOnColor;
  Color get buttonLabelTransparentHoveredOnColor;
  Color get buttonLabelTransparentPressedOnColor;
  Color get buttonLabelTransparentSelectedOnColor;
  Color get buttonIconTransparentHoveredOnColor;
  Color get buttonIconTransparentPressedOnColor;
  Color get buttonIconTransparentSelectedOnColor;

  // ── Chip ────────────────────────────────────────────────────────
  Color get chipBackgroundNeutralDefault;
  Color get chipBackgroundNeutralHovered;
  Color get chipBackgroundNeutralSelected;
  Color get chipBackgroundNeutralFocused;
  Color get chipBackgroundPrimaryFocused;
  Color get chipBackgroundOnColorDefault;
  Color get chipBackgroundOnColorHovered;
  Color get chipBackgroundOnColorPressed;
  Color get chipBackgroundOnColorSelected;
  Color get chipBackgroundOnColorFocused;
  Color get chipBackgroundOnColorDiabled;

  // ── Link ────────────────────────────────────────────────────────
  Color get linkPrimary;
  Color get linkPrimaryHovered;
  Color get linkPrimaryPressed;
  Color get linkPrimaryFocused;
  Color get linkPrimaryVisited;
  Color get linkIconPrimaryHovered;
  Color get linkIconPrimaryPressed;
  Color get linkIconPrimaryFocused;
  Color get linkIconPrimaryVisited;
  Color get linkNeutral;
  Color get linkNeutralHovered;
  Color get linkIconNeutralHovered;
  Color get linkNeutralPressed;
  Color get linkIconNeutralPressed;
  Color get linkNeutralFocused;
  Color get linkIconNeutralFocused;
  Color get linkNeutralVisited;
  Color get linkIconNeutralVisited;
  Color get linkDanger;
  Color get linkDangerHovered;
  Color get linkIconDangerHovered;
  Color get linkDangerPressed;
  Color get linkIconDangerPressed;
  Color get linkDangerFocused;
  Color get linkIconDangerFocused;
  Color get linkDangerVisited;
  Color get linkIconDangerVisited;
  Color get linkOncolor;
  Color get linkOncolorHovered;
  Color get linkIconOncolorHovered;
  Color get linkOncolorPressed;
  Color get linkIconOncolorPressed;
  Color get linkOncolorFocused;
  Color get linkLinkOncolorFocused;
  Color get linkOncolorVisited;
  Color get linkIconOncolorVisited;
  Color get linkOncolorDisabled;
  Color get linkIconOncolorDisabled;

  // ── Icon ────────────────────────────────────────────────────────
  Color get iconOncolor;
  Color get iconDefault;
  Color get iconDefault500;
  Color get iconDefault400;
  Color get iconPrimary;
  Color get iconPrimaryLight;
  Color get iconPrimary400;
  Color get iconNeutral;
  Color get iconNeutralLight;
  Color get iconSecondaryLight;
  Color get iconTertiaryLight;
  Color get iconSuccess;
  Color get iconSuccessLight;
  Color get iconInfo;
  Color get iconInfoLight;
  Color get iconWarning;
  Color get iconWarningLight;
  Color get iconError;
  Color get iconErrorLight;
  Color get backgroundWarningLight;
  Color get backgroundErrorLight;
  Color get backgroundBrandLight;
  Color get backgroundInfoLight;
  Color get backgroundSuccessLight;
  Color get unselectedTabIcon;

  // ── Tag ─────────────────────────────────────────────────────────
  Color get tagBackgroundNeutral;
  Color get tagBackgroundNeutralLight;
  Color get tagBackgroundOnColor;
  Color get tagTextNeutral;
  Color get tagTextSuccess;
  Color get tagTextInfo;
  Color get tagTextWarning;
  Color get tagTextError;
  Color get tagIconNeutral;
  Color get tagIconSuccess;
  Color get tagIconInfo;
  Color get tagIconWarning;
  Color get tagIconError;
  Color get tagBackgroundSuccess;
  Color get tagBackgroundSuccessLight;
  Color get tagBackgroundInfo;
  Color get tagBackgroundInfoLight;
  Color get tagBackgroundWarning;
  Color get tagBackgroundWarningLight;
  Color get tagBackgroundError;
  Color get tagBackgroundErrorLight;
  Color get tagBorderNeutral;
  Color get tagBorderNeutralLight;
  Color get tagBorderOnColor;
  Color get tagBorderSuccess;
  Color get tagBorderSuccessLight;
  Color get tagBorderInfo;
  Color get tagBorderInfoLight;
  Color get tagBorderWarning;
  Color get tagBorderWarningLight;
  Color get tagBorderError;
  Color get tagBorderErrorLight;
  Color get tagDot;

  // ── Form ──────────────────────────────────────────────────────── //Remove the one that is not in the theme file
  Color get textFormTitle;
  Color get textFormParagraph;
  Color get fieldTextLabel;
  Color get fieldTextPlaceholder;
  Color get fieldTextHovered;
  Color get fieldTextFocused;
  Color get fieldTextPressed;
  Color get fieldTextFilled;
  Color get fieldTextReadonly;
  Color get fieldTextHelper;
  Color get fieldBackgroundDefault;
  Color get fieldBackgroundLighter;
  Color get fieldBackgroundDarker;
  Color get fieldBackgroundPressed;
  Color get fieldBorderDefault;
  Color get fieldBorderHovered;
  Color get fieldBorderPressed;
  Color get fieldBorderError;
  Color get optionBackgroundHover;
  Color get optionBackgroundPressed;
  Color get datecellBackgroundDefault;
  Color get datecellBackgroundHovered;
  Color get datecellBackgroundPressed;
  Color get datecellBackgroundFocused;
  Color get datecellTodayBackgroundDefault;
  Color get datecellTodayBackgroundHovered;
  Color get datecellTodayBackgroundPressed;
  Color get datecellTodayBackgroundFocused;
  Color get datecellBackgroundDisabled;
  Color get datecellBackground600;
  Color get datecellBackground300;
  Color get datecellBackground200;
  Color get datecellBackground100;
  Color get textareaScrollbarBar;

  // ── Controls ────────────────────────────────────────────────────
  Color get controlPrimary;
  Color get controlPrimaryChecked;
  Color get controlPrimaryHovered;
  Color get controlPrimaryPressed;
  Color get controlPrimaryFocused;
  Color get controlNeutralChecked;
  Color get controlNeutralHovered;
  Color get controlNeutralPressed;
  Color get controlNeutralFocused;
  Color get controlPrimaryReadonly;
  Color get controlPressed;
  Color get controlRippleEffect;
  Color get controlBorder;
  Color get controlIconHovered;
  Color get controlIconPressed;
  Color get controlIconDisabled;
  Color get controlBoarderDisabled;
  Color get controlDisabled;

  // ── Table ───────────────────────────────────────────────────────
  Color get tableCellBorder;
  Color get tableCellBorderInverse;
  Color get tableTextHead;
  Color get tableTextBody;
  Color get tableBackgroundDisabled;
  Color get tableBackgroundHoverSelected;
  Color get tableBackgroundHeader;
  Color get tableBackgroundRow;
  Color get tableBackgroundRowSelectedHovered;
  Color get tableBoarderRowSelectedHovered;
  Color get tableBackgroundRowSelect;
  Color get tableBackgroundRowHovered;
  Color get tableBackgroundRowAlt;

  // ── Stepper ─────────────────────────────────────────────────────
  Color get stepperButtonCompleted;
  Color get stepperButtonCompletedHovered;
  Color get stepperButtonCurrent;
  Color get stepperButtonCurrentHovered;
  Color get stepperButtonUpcomming;
  Color get stepperButtonUpcommingHovered;
  Color get stepperButtonBackground;
  Color get stepperTextPrimary;
  Color get stepperTextSecondary;
  Color get stepperTextTertiary;
  Color get stepperLineCompleted;
  Color get stepperLineCompletedHovered;
  Color get stepperLineCurrent;
  Color get stepperLineUpcomming;
  Color get stepperLineUpcommingHovered;

  // ── Tooltip ─────────────────────────────────────────────────────
  Color get tooltipBackgroundLight;
  Color get tooltipTextHeadingLight;
  Color get tooltipTextParagraphLight;
  Color get tooltipBackgroundDark;
  Color get tooltipTextHeadingDark;
  Color get tooltipTextParagraphDark;

  // ── Charts ──────────────────────────────────────────────────────
  Color get chartsBlue;
  Color get chartsLavendar;
  Color get chartsGreen;
  Color get chartsGold;
  Color get chartsRed;
  Color get chartsYellow;
  Color get chartsGreenPrimary200;

  // ── Progress Bar ────────────────────────────────────────────────
  Color get progressBarNeutral;

  // ── Alpha ───────────────────────────────────────────────────────
  Color get alphaWhite0;
  Color get alphaWhite10;
  Color get alphaWhite20;
  Color get alphaWhite30;
  Color get alphaWhite40;
  Color get alphaWhite50;
  Color get alphaWhite60;
  Color get alphaWhite70;
  Color get alphaWhite80;
  Color get alphaWhite90;
  Color get alphaWhite100;
  Color get alphaBlack0;
  Color get alphaBlack10;
  Color get alphaBlack20;
  Color get alphaBlack30;
  Color get alphaBlack40;
  Color get alphaBlack50;
  Color get alphaBlack60;
  Color get alphaBlack70;
  Color get alphaBlack80;
  Color get alphaBlack90;
  Color get alphaBlack100;
  Color get alphaPrimary10;
  Color get alphaPrimary20;
  Color get alphaWarning10;
  Color get alphaWarning20;
  Color get alphaError10;
  Color get alphaError20;
  Color get alphaInfo10;
  Color get alphaInfo20;
  Color get alphaSuccess10;
  Color get alphaSuccess20;
}

class _DgaSemanticColorsLight extends DgaSemanticColors {
  const _DgaSemanticColorsLight();

  // Background
  @override
  Color get backgroundWhite => DgaPrimitives.white;
  @override
  Color get backgroundBody => DgaPrimitives.neutral50;
  @override
  Color get backgroundMenu => DgaPrimitives.white;
  @override
  Color get backgroundCard => DgaPrimitives.white;
  @override
  Color get surfaceOncolor => DgaPrimitives.white;
  @override
  Color get backgroundBlack => DgaPrimitives.black;
  @override
  Color get backgroundNeutral800 => DgaPrimitives.neutral800;
  @override
  Color get backgroundNeutral400 => DgaPrimitives.neutral400;
  @override
  Color get backgroundNeutral300 => DgaPrimitives.neutral300;
  @override
  Color get backgroundNeutral200 => DgaPrimitives.neutral200;
  @override
  Color get backgroundNeutral100 => DgaPrimitives.neutral100;
  @override
  Color get backgroundNeutral50 => DgaPrimitives.neutral50;
  @override
  Color get backgroundNeutral25 => DgaPrimitives.neutral25;
  @override
  Color get backgroundPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get backgroundPrimary400 => DgaPrimitives.saFlag400;
  @override
  Color get backgroundPrimary200 => DgaPrimitives.saFlag200;
  @override
  Color get backgroundPrimary50 => DgaPrimitives.saFlag50;
  @override
  Color get backgroundPrimary25 => DgaPrimitives.saFlag25;
  @override
  Color get backgroundSecondary50 => DgaPrimitives.gold50;
  @override
  Color get backgroundSecondary25 => DgaPrimitives.gold25;
  @override
  Color get backgroundTertiary50 => DgaPrimitives.lavendar50;
  @override
  Color get backgroundTertiary25 => DgaPrimitives.lavendar25;
  @override
  Color get backgroundSuccess => DgaPrimitives.green600;
  @override
  Color get backgroundSuccess50 => DgaPrimitives.green50;
  @override
  Color get backgroundSuccess25 => DgaPrimitives.green25;
  @override
  Color get backgroundInfo => DgaPrimitives.blue600;
  @override
  Color get backgroundInfo50 => DgaPrimitives.blue50;
  @override
  Color get backgroundInfo25 => DgaPrimitives.blue25;
  @override
  Color get backgroundWarning => DgaPrimitives.yellow600;
  @override
  Color get backgroundWarning50 => DgaPrimitives.yellow50;
  @override
  Color get backgroundWarning25 => DgaPrimitives.yellow25;
  @override
  Color get backgroundError => DgaPrimitives.red600;
  @override
  Color get backgroundError50 => DgaPrimitives.red50;
  @override
  Color get backgroundError25 => DgaPrimitives.red25;
  @override
  Color get backgroundSaFlag => DgaPrimitives.green900;
  @override
  Color get backgroundSaFlag50 => DgaPrimitives.green50;
  @override
  Color get backgroundSaFlag25 => DgaPrimitives.green25;
  @override
  Color get backgroundNotificationWhite => DgaPrimitives.white;
  @override
  Color get backgroundNavHeader => DgaPrimitives.saFlag800;

  // Text
  @override
  Color get textDefault => DgaPrimitives.black;
  @override
  Color get textWhite => DgaPrimitives.white;
  @override
  Color get textPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get textPrimarySaFlag => DgaPrimitives.saFlag800;
  @override
  Color get textDisplay => DgaPrimitives.neutral800;
  @override
  Color get textPrimaryParagraph => DgaPrimitives.neutral700;
  @override
  Color get textSecondaryParagraph => DgaPrimitives.neutral500;
  @override
  Color get textOncolorPrimary => DgaPrimitives.white;
  @override
  Color get textOncolorSecondary => DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get textOncolorTertiary => DgaPrimitives.white.withValues(alpha: 0.7);
  @override
  Color get textSuccess => DgaPrimitives.green700;
  @override
  Color get textInfo => DgaPrimitives.blue700;
  @override
  Color get textWarning => DgaPrimitives.yellow700;
  @override
  Color get textError => DgaPrimitives.red700;
  @override
  Color get textPrimaryLight => DgaPrimitives.saFlag300;

  // Global
  @override
  Color get textDefaultDisabled => DgaPrimitives.neutral400;
  @override
  Color get textDefaultOncolorDisabled =>
      DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get globalBorderDisabled => DgaPrimitives.neutral400;
  @override
  Color get backgroundDisabled => DgaPrimitives.neutral200;
  @override
  Color get backgroundDisabledPrimary => DgaPrimitives.saFlag200;
  @override
  Color get backgroundInverseDisabled => DgaPrimitives.neutral100;
  @override
  Color get iconDefaultDisabled => DgaPrimitives.neutral400;
  @override
  Color get iconDefaultOncolorDisabled =>
      DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get globalControlDisabled => DgaPrimitives.neutral400;

  // Border
  @override
  Color get borderWhite => DgaPrimitives.white;
  @override
  Color get borderWhite40 => DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get borderBlack => DgaPrimitives.black;
  @override
  Color get borderPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get borderPrimaryLight => DgaPrimitives.saFlag200;
  @override
  Color get borderNeutralPrimary => DgaPrimitives.neutral300;
  @override
  Color get borderNeutralSecondary => DgaPrimitives.neutral200;
  @override
  Color get borderNeutralTertiary => DgaPrimitives.neutral100;
  @override
  Color get borderBackgroundWhite => DgaPrimitives.neutral100;
  @override
  Color get borderBackgroundNeutral => DgaPrimitives.neutral300;
  @override
  Color get borderTransparent10 => DgaPrimitives.white.withValues(alpha: 0.1);
  @override
  Color get borderOncolorTransparent30 =>
      DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get borderSuccess => DgaPrimitives.green700;
  @override
  Color get borderSuccessLight => DgaPrimitives.green200;
  @override
  Color get borderInfo => DgaPrimitives.blue700;
  @override
  Color get borderInfoLight => DgaPrimitives.blue200;
  @override
  Color get borderWarning => DgaPrimitives.yellow700;
  @override
  Color get borderWarningLight => DgaPrimitives.yellow200;
  @override
  Color get borderError => DgaPrimitives.red700;
  @override
  Color get borderErrorLight => DgaPrimitives.red200;
  @override
  Color get borderDisabled => DgaPrimitives.neutral300;

  // Button
  @override
  Color get buttonBackgroundBlackDefault => DgaPrimitives.neutral950;
  @override
  Color get buttonBackgroundBlackHovered => DgaPrimitives.neutral800;
  @override
  Color get buttonBackgroundBlackPressed => DgaPrimitives.neutral600;
  @override
  Color get buttonBackgroundBlackSelected => DgaPrimitives.neutral700;
  @override
  Color get buttonBackgroundBlackFocused => DgaPrimitives.neutral950;
  @override
  Color get buttonBackgroundPrimaryDefault => DgaPrimitives.saFlag600Primary;
  @override
  Color get buttonBackgroundPrimaryHovered => DgaPrimitives.saFlag700;
  @override
  Color get buttonBackgroundPrimaryPressed => DgaPrimitives.saFlag900;
  @override
  Color get buttonBackgroundPrimarySelected => DgaPrimitives.saFlag800;
  @override
  Color get buttonBackgroundPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get buttonBackgroundNeutralDefault => DgaPrimitives.neutral100;
  @override
  Color get buttonBackgroundNeutralHovered => DgaPrimitives.neutral100;
  @override
  Color get buttonBackgroundNeutralPressed => DgaPrimitives.neutral200;
  @override
  Color get buttonBackgroundNeutralSelected => DgaPrimitives.neutral200;
  @override
  Color get buttonBackgroundNeutralFocused => DgaPrimitives.neutral100;
  @override
  Color get buttonBackgroundDangerPrimaryDefault => DgaPrimitives.red600;
  @override
  Color get buttonBackgroundDangerPrimaryHovered => DgaPrimitives.red700;
  @override
  Color get buttonBackgroundDangerPrimaryPressed => DgaPrimitives.red900;
  @override
  Color get buttonBackgroundDangerPrimarySelected => DgaPrimitives.red800;
  @override
  Color get buttonBackgroundDangerPrimaryFocused => DgaPrimitives.red600;
  @override
  Color get buttonLabelDangerPrimaryDefaultOncolor => DgaPrimitives.red200;
  @override
  Color get buttonLabelDangerPrimaryHoveredOncolor => DgaPrimitives.red300;
  @override
  Color get buttonLabelDangerPrimaryPressedOncolor => DgaPrimitives.red400;
  @override
  Color get buttonBackgroundDangerSecondaryDefault => DgaPrimitives.red50;
  @override
  Color get buttonBackgroundDangerSecondaryHovered => DgaPrimitives.red100;
  @override
  Color get buttonBackgroundDangerSecondaryPressed => DgaPrimitives.red200;
  @override
  Color get buttonBackgroundDangerSecondarySelected => DgaPrimitives.red50;
  @override
  Color get buttonBackgroundDangerSecondaryFocused => DgaPrimitives.red50;
  @override
  Color get buttonBackgroundOncolorDefault => DgaPrimitives.white;
  @override
  Color get buttonBackgroundOncolorHovered =>
      DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get buttonBackgroundOncolorPressed =>
      DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get buttonBackgroundOncolorSelected =>
      DgaPrimitives.white.withValues(alpha: 0.7);
  @override
  Color get buttonBackgroundOncolorFocused => DgaPrimitives.white;
  @override
  Color get buttonBackgroundTransparentDefault =>
      DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get buttonBackgroundTransparentHovered =>
      DgaPrimitives.white.withValues(alpha: 0.2);
  @override
  Color get buttonBackgroundTransparentPressed =>
      DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get buttonBackgroundTransparentSelected =>
      DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get buttonBackgroundTransparentFocused =>
      DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get buttonBackgroundDisabledOnColor =>
      DgaPrimitives.white.withValues(alpha: 0.2);
  @override
  Color get buttonLabelTransparentHoveredOnColor => DgaPrimitives.saFlag400;
  @override
  Color get buttonLabelTransparentPressedOnColor => DgaPrimitives.saFlag300;
  @override
  Color get buttonLabelTransparentSelectedOnColor => DgaPrimitives.saFlag400;
  @override
  Color get buttonIconTransparentHoveredOnColor => DgaPrimitives.saFlag400;
  @override
  Color get buttonIconTransparentPressedOnColor => DgaPrimitives.saFlag300;
  @override
  Color get buttonIconTransparentSelectedOnColor => DgaPrimitives.saFlag400;

  // Chip
  @override
  Color get chipBackgroundNeutralDefault => DgaPrimitives.neutral100;
  @override
  Color get chipBackgroundNeutralHovered => DgaPrimitives.neutral200;
  @override
  Color get chipBackgroundNeutralSelected => DgaPrimitives.neutral700;
  @override
  Color get chipBackgroundNeutralFocused => DgaPrimitives.neutral100;
  @override
  Color get chipBackgroundPrimaryFocused => DgaPrimitives.saFlag100;
  @override
  Color get chipBackgroundOnColorDefault => DgaPrimitives.white;
  @override
  Color get chipBackgroundOnColorHovered =>
      DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get chipBackgroundOnColorPressed =>
      DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get chipBackgroundOnColorSelected =>
      DgaPrimitives.white.withValues(alpha: 0.7);
  @override
  Color get chipBackgroundOnColorFocused => DgaPrimitives.white;
  @override
  Color get chipBackgroundOnColorDiabled =>
      DgaPrimitives.white.withValues(alpha: 0.2);

  // Link
  @override
  Color get linkPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get linkPrimaryHovered => DgaPrimitives.saFlag400;
  @override
  Color get linkPrimaryPressed => DgaPrimitives.saFlag300;
  @override
  Color get linkPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get linkPrimaryVisited => DgaPrimitives.saFlag800;
  @override
  Color get linkIconPrimaryHovered => DgaPrimitives.saFlag400;
  @override
  Color get linkIconPrimaryPressed => DgaPrimitives.saFlag300;
  @override
  Color get linkIconPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get linkIconPrimaryVisited => DgaPrimitives.saFlag800;
  @override
  Color get linkNeutral => DgaPrimitives.neutral700;
  @override
  Color get linkNeutralHovered => DgaPrimitives.neutral500;
  @override
  Color get linkIconNeutralHovered => DgaPrimitives.neutral500;
  @override
  Color get linkNeutralPressed => DgaPrimitives.neutral400;
  @override
  Color get linkIconNeutralPressed => DgaPrimitives.neutral400;
  @override
  Color get linkNeutralFocused => DgaPrimitives.neutral700;
  @override
  Color get linkIconNeutralFocused => DgaPrimitives.neutral700;
  @override
  Color get linkNeutralVisited => DgaPrimitives.neutral600;
  @override
  Color get linkIconNeutralVisited => DgaPrimitives.neutral600;
  @override
  Color get linkDanger => DgaPrimitives.red600;
  @override
  Color get linkDangerHovered => DgaPrimitives.red700;
  @override
  Color get linkIconDangerHovered => DgaPrimitives.red700;
  @override
  Color get linkDangerPressed => DgaPrimitives.red900;
  @override
  Color get linkIconDangerPressed => DgaPrimitives.red900;
  @override
  Color get linkDangerFocused => DgaPrimitives.red600;
  @override
  Color get linkIconDangerFocused => DgaPrimitives.red600;
  @override
  Color get linkDangerVisited => DgaPrimitives.red800;
  @override
  Color get linkIconDangerVisited => DgaPrimitives.red800;
  @override
  Color get linkOncolor => DgaPrimitives.white;
  @override
  Color get linkOncolorHovered => DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get linkIconOncolorHovered =>
      DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get linkOncolorPressed => DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get linkIconOncolorPressed =>
      DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get linkOncolorFocused => DgaPrimitives.white;
  @override
  Color get linkLinkOncolorFocused => DgaPrimitives.white;
  @override
  Color get linkOncolorVisited => DgaPrimitives.white.withValues(alpha: 0.9);
  @override
  Color get linkIconOncolorVisited =>
      DgaPrimitives.white.withValues(alpha: 0.9);
  @override
  Color get linkOncolorDisabled => DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get linkIconOncolorDisabled =>
      DgaPrimitives.white.withValues(alpha: 0.3);

  // Icon
  @override
  Color get iconOncolor => DgaPrimitives.white;
  @override
  Color get iconDefault => DgaPrimitives.black;
  @override
  Color get iconDefault500 => DgaPrimitives.neutral500;
  @override
  Color get iconDefault400 => DgaPrimitives.neutral400;
  @override
  Color get iconPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get iconPrimaryLight => DgaPrimitives.saFlag50;
  @override
  Color get iconPrimary400 => DgaPrimitives.saFlag400;
  @override
  Color get iconNeutral => DgaPrimitives.neutral700;
  @override
  Color get iconNeutralLight => DgaPrimitives.neutral50;
  @override
  Color get iconSecondaryLight => DgaPrimitives.gold50;
  @override
  Color get iconTertiaryLight => DgaPrimitives.lavendar50;
  @override
  Color get iconSuccess => DgaPrimitives.green700;
  @override
  Color get iconSuccessLight => DgaPrimitives.green50;
  @override
  Color get iconInfo => DgaPrimitives.blue700;
  @override
  Color get iconInfoLight => DgaPrimitives.blue50;
  @override
  Color get iconWarning => DgaPrimitives.yellow700;
  @override
  Color get iconWarningLight => DgaPrimitives.yellow50;
  @override
  Color get iconError => DgaPrimitives.red700;
  @override
  Color get iconErrorLight => DgaPrimitives.red50;
  @override
  Color get backgroundWarningLight => DgaPrimitives.yellow50;
  @override
  Color get backgroundErrorLight => DgaPrimitives.red50;
  @override
  Color get backgroundBrandLight => DgaPrimitives.saFlag50;
  @override
  Color get backgroundInfoLight => DgaPrimitives.blue50;
  @override
  Color get backgroundSuccessLight => DgaPrimitives.green50;
  @override
  Color get unselectedTabIcon => DgaPrimitives.neutral700;

  // Tag
  @override
  Color get tagBackgroundNeutral => DgaPrimitives.neutral600;
  @override
  Color get tagBackgroundNeutralLight => DgaPrimitives.neutral50;
  @override
  Color get tagBackgroundOnColor => DgaPrimitives.white.withValues(alpha: 0.2);
  @override
  Color get tagTextNeutral => DgaPrimitives.neutral800;
  @override
  Color get tagTextSuccess => DgaPrimitives.green800;
  @override
  Color get tagTextInfo => DgaPrimitives.blue800;
  @override
  Color get tagTextWarning => DgaPrimitives.yellow800;
  @override
  Color get tagTextError => DgaPrimitives.red800;
  @override
  Color get tagIconNeutral => DgaPrimitives.neutral800;
  @override
  Color get tagIconSuccess => DgaPrimitives.green800;
  @override
  Color get tagIconInfo => DgaPrimitives.blue800;
  @override
  Color get tagIconWarning => DgaPrimitives.yellow800;
  @override
  Color get tagIconError => DgaPrimitives.red800;
  @override
  Color get tagBackgroundSuccess => DgaPrimitives.green700;
  @override
  Color get tagBackgroundSuccessLight => DgaPrimitives.green50;
  @override
  Color get tagBackgroundInfo => DgaPrimitives.blue600;
  @override
  Color get tagBackgroundInfoLight => DgaPrimitives.blue50;
  @override
  Color get tagBackgroundWarning => DgaPrimitives.yellow700;
  @override
  Color get tagBackgroundWarningLight => DgaPrimitives.yellow50;
  @override
  Color get tagBackgroundError => DgaPrimitives.red600;
  @override
  Color get tagBackgroundErrorLight => DgaPrimitives.red50;
  @override
  Color get tagBorderNeutral => DgaPrimitives.neutral600;
  @override
  Color get tagBorderNeutralLight => DgaPrimitives.neutral50;
  @override
  Color get tagBorderOnColor => DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get tagBorderSuccess => DgaPrimitives.green700;
  @override
  Color get tagBorderSuccessLight => DgaPrimitives.green200;
  @override
  Color get tagBorderInfo => DgaPrimitives.blue700;
  @override
  Color get tagBorderInfoLight => DgaPrimitives.blue200;
  @override
  Color get tagBorderWarning => DgaPrimitives.yellow700;
  @override
  Color get tagBorderWarningLight => DgaPrimitives.yellow200;
  @override
  Color get tagBorderError => DgaPrimitives.red700;
  @override
  Color get tagBorderErrorLight => DgaPrimitives.red200;
  @override
  Color get tagDot => DgaPrimitives.white.withValues(alpha: 0.6);

  // Form
  @override
  Color get textFormTitle => DgaPrimitives.black;
  @override
  Color get textFormParagraph => DgaPrimitives.neutral500;
  @override
  Color get fieldTextLabel => DgaPrimitives.black;
  @override
  Color get fieldTextPlaceholder => DgaPrimitives.neutral500;
  @override
  Color get fieldTextHovered => DgaPrimitives.black;
  @override
  Color get fieldTextFocused => DgaPrimitives.neutral700;
  @override
  Color get fieldTextPressed => DgaPrimitives.neutral700;
  @override
  Color get fieldTextFilled => DgaPrimitives.black;
  @override
  Color get fieldTextReadonly => DgaPrimitives.black;
  @override
  Color get fieldTextHelper => DgaPrimitives.neutral500;
  @override
  Color get fieldBackgroundDefault => DgaPrimitives.white;
  @override
  Color get fieldBackgroundLighter => DgaPrimitives.neutral25;
  @override
  Color get fieldBackgroundDarker => DgaPrimitives.neutral100;
  @override
  Color get fieldBackgroundPressed => DgaPrimitives.neutral100;
  @override
  Color get fieldBorderDefault => DgaPrimitives.neutral400;
  @override
  Color get fieldBorderHovered => DgaPrimitives.neutral700;
  @override
  Color get fieldBorderPressed => DgaPrimitives.neutral950;
  @override
  Color get fieldBorderError => DgaPrimitives.red700;
  @override
  Color get optionBackgroundHover => DgaPrimitives.neutral100;
  @override
  Color get optionBackgroundPressed => DgaPrimitives.neutral200;
  @override
  Color get datecellBackgroundDefault => DgaPrimitives.saFlag600Primary;
  @override
  Color get datecellBackgroundHovered => DgaPrimitives.saFlag700;
  @override
  Color get datecellBackgroundPressed => DgaPrimitives.saFlag900;
  @override
  Color get datecellBackgroundFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get datecellTodayBackgroundDefault =>
      DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get datecellTodayBackgroundHovered => DgaPrimitives.neutral200;
  @override
  Color get datecellTodayBackgroundPressed => DgaPrimitives.neutral300;
  @override
  Color get datecellTodayBackgroundFocused =>
      DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get datecellBackgroundDisabled => DgaPrimitives.white;
  @override
  Color get datecellBackground600 => DgaPrimitives.saFlag600Primary;
  @override
  Color get datecellBackground300 => DgaPrimitives.saFlag300;
  @override
  Color get datecellBackground200 => DgaPrimitives.saFlag200;
  @override
  Color get datecellBackground100 => DgaPrimitives.saFlag100;
  @override
  Color get textareaScrollbarBar => DgaPrimitives.neutral300;

  // Controls
  @override
  Color get controlPrimary => DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get controlPrimaryChecked => DgaPrimitives.saFlag600Primary;
  @override
  Color get controlPrimaryHovered => DgaPrimitives.saFlag800;
  @override
  Color get controlPrimaryPressed => DgaPrimitives.saFlag900;
  @override
  Color get controlPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get controlNeutralChecked => DgaPrimitives.neutral950;
  @override
  Color get controlNeutralHovered => DgaPrimitives.neutral600;
  @override
  Color get controlNeutralPressed => DgaPrimitives.neutral500;
  @override
  Color get controlNeutralFocused => DgaPrimitives.neutral950;
  @override
  Color get controlPrimaryReadonly => DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get controlPressed => DgaPrimitives.neutral300;
  @override
  Color get controlRippleEffect => DgaPrimitives.neutral100;
  @override
  Color get controlBorder => DgaPrimitives.neutral500;
  @override
  Color get controlIconHovered => DgaPrimitives.white;
  @override
  Color get controlIconPressed => DgaPrimitives.white;
  @override
  Color get controlIconDisabled => DgaPrimitives.white;
  @override
  Color get controlBoarderDisabled => DgaPrimitives.neutral400;
  @override
  Color get controlDisabled => DgaPrimitives.neutral300;

  // Table
  @override
  Color get tableCellBorder => DgaPrimitives.neutral300;
  @override
  Color get tableCellBorderInverse => DgaPrimitives.black;
  @override
  Color get tableTextHead => DgaPrimitives.neutral700;
  @override
  Color get tableTextBody => DgaPrimitives.black;
  @override
  Color get tableBackgroundDisabled => DgaPrimitives.neutral200;
  @override
  Color get tableBackgroundHoverSelected => DgaPrimitives.neutral50;
  @override
  Color get tableBackgroundHeader => DgaPrimitives.neutral100;
  @override
  Color get tableBackgroundRow => DgaPrimitives.neutral50;
  @override
  Color get tableBackgroundRowSelectedHovered => DgaPrimitives.saFlag50;
  @override
  Color get tableBoarderRowSelectedHovered => DgaPrimitives.neutral100;
  @override
  Color get tableBackgroundRowSelect => DgaPrimitives.saFlag50;
  @override
  Color get tableBackgroundRowHovered => DgaPrimitives.neutral100;
  @override
  Color get tableBackgroundRowAlt => DgaPrimitives.neutral50;

  // Stepper
  @override
  Color get stepperButtonCompleted => DgaPrimitives.saFlag600Primary;
  @override
  Color get stepperButtonCompletedHovered => DgaPrimitives.saFlag700;
  @override
  Color get stepperButtonCurrent => DgaPrimitives.saFlag600Primary;
  @override
  Color get stepperButtonCurrentHovered => DgaPrimitives.saFlag700;
  @override
  Color get stepperButtonUpcomming => DgaPrimitives.neutral300;
  @override
  Color get stepperButtonUpcommingHovered => DgaPrimitives.neutral400;
  @override
  Color get stepperButtonBackground => DgaPrimitives.white;
  @override
  Color get stepperTextPrimary => DgaPrimitives.neutral800;
  @override
  Color get stepperTextSecondary => DgaPrimitives.neutral700;
  @override
  Color get stepperTextTertiary => DgaPrimitives.neutral500;
  @override
  Color get stepperLineCompleted => DgaPrimitives.saFlag600Primary;
  @override
  Color get stepperLineCompletedHovered => DgaPrimitives.saFlag700;
  @override
  Color get stepperLineCurrent => DgaPrimitives.neutral300;
  @override
  Color get stepperLineUpcomming => DgaPrimitives.neutral300;
  @override
  Color get stepperLineUpcommingHovered => DgaPrimitives.neutral400;

  // Tooltip
  @override
  Color get tooltipBackgroundLight => DgaPrimitives.white;
  @override
  Color get tooltipTextHeadingLight => DgaPrimitives.neutral800;
  @override
  Color get tooltipTextParagraphLight => DgaPrimitives.neutral700;
  @override
  Color get tooltipBackgroundDark => DgaPrimitives.neutral800;
  @override
  Color get tooltipTextHeadingDark => DgaPrimitives.neutral50;
  @override
  Color get tooltipTextParagraphDark => DgaPrimitives.neutral100;

  // Charts
  @override
  Color get chartsBlue => DgaPrimitives.blue400;
  @override
  Color get chartsLavendar => DgaPrimitives.lavendar500Primary;
  @override
  Color get chartsGreen => DgaPrimitives.saFlag300;
  @override
  Color get chartsGold => DgaPrimitives.gold400;
  @override
  Color get chartsRed => DgaPrimitives.red400;
  @override
  Color get chartsYellow => DgaPrimitives.yellow400;
  @override
  Color get chartsGreenPrimary200 => DgaPrimitives.saFlag200;

  // Progress Bar
  @override
  Color get progressBarNeutral => DgaPrimitives.neutral700;

  // Alpha
  @override
  Color get alphaWhite0 => DgaPrimitives.white.withValues(alpha: 0);
  @override
  Color get alphaWhite10 => DgaPrimitives.white.withValues(alpha: 0.1);
  @override
  Color get alphaWhite20 => DgaPrimitives.white.withValues(alpha: 0.2);
  @override
  Color get alphaWhite30 => DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get alphaWhite40 => DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get alphaWhite50 => DgaPrimitives.white.withValues(alpha: 0.5);
  @override
  Color get alphaWhite60 => DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get alphaWhite70 => DgaPrimitives.white.withValues(alpha: 0.7);
  @override
  Color get alphaWhite80 => DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get alphaWhite90 => DgaPrimitives.white.withValues(alpha: 0.9);
  @override
  Color get alphaWhite100 => DgaPrimitives.white;
  @override
  Color get alphaBlack0 => DgaPrimitives.black.withValues(alpha: 0);
  @override
  Color get alphaBlack10 => DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get alphaBlack20 => DgaPrimitives.black.withValues(alpha: 0.2);
  @override
  Color get alphaBlack30 => DgaPrimitives.black.withValues(alpha: 0.3);
  @override
  Color get alphaBlack40 => DgaPrimitives.black.withValues(alpha: 0.4);
  @override
  Color get alphaBlack50 => DgaPrimitives.black.withValues(alpha: 0.5);
  @override
  Color get alphaBlack60 => DgaPrimitives.black.withValues(alpha: 0.6);
  @override
  Color get alphaBlack70 => DgaPrimitives.black.withValues(alpha: 0.7);
  @override
  Color get alphaBlack80 => DgaPrimitives.black.withValues(alpha: 0.8);
  @override
  Color get alphaBlack90 => DgaPrimitives.black.withValues(alpha: 0.9);
  @override
  Color get alphaBlack100 => DgaPrimitives.black;
  @override
  Color get alphaPrimary10 =>
      DgaPrimitives.saFlag600Primary.withValues(alpha: 0.1);
  @override
  Color get alphaPrimary20 =>
      DgaPrimitives.saFlag600Primary.withValues(alpha: 0.2);
  @override
  Color get alphaWarning10 => DgaPrimitives.yellow600.withValues(alpha: 0.1);
  @override
  Color get alphaWarning20 => DgaPrimitives.yellow600.withValues(alpha: 0.2);
  @override
  Color get alphaError10 => DgaPrimitives.red600.withValues(alpha: 0.1);
  @override
  Color get alphaError20 => DgaPrimitives.red600.withValues(alpha: 0.2);
  @override
  Color get alphaInfo10 => DgaPrimitives.blue600.withValues(alpha: 0.1);
  @override
  Color get alphaInfo20 => DgaPrimitives.blue600.withValues(alpha: 0.2);
  @override
  Color get alphaSuccess10 => DgaPrimitives.green600.withValues(alpha: 0.1);
  @override
  Color get alphaSuccess20 => DgaPrimitives.green600.withValues(alpha: 0.2);
}

class _DgaSemanticColorsDark extends DgaSemanticColors {
  const _DgaSemanticColorsDark();

  // Background
  @override
  Color get backgroundWhite => DgaPrimitives.neutral950;
  @override
  Color get backgroundBody => DgaPrimitives.neutral900;
  @override
  Color get backgroundMenu => DgaPrimitives.neutral800;
  @override
  Color get backgroundCard => DgaPrimitives.neutral800;
  @override
  Color get surfaceOncolor => DgaPrimitives.white;
  @override
  Color get backgroundBlack => DgaPrimitives.white;
  @override
  Color get backgroundNeutral800 => DgaPrimitives.neutral600;
  @override
  Color get backgroundNeutral400 => DgaPrimitives.neutral400;
  @override
  Color get backgroundNeutral300 => DgaPrimitives.neutral500;
  @override
  Color get backgroundNeutral200 => DgaPrimitives.neutral600;
  @override
  Color get backgroundNeutral100 => DgaPrimitives.neutral800;
  @override
  Color get backgroundNeutral50 => DgaPrimitives.neutral900;
  @override
  Color get backgroundNeutral25 => DgaPrimitives.neutral950;
  @override
  Color get backgroundPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get backgroundPrimary400 => DgaPrimitives.saFlag400;
  @override
  Color get backgroundPrimary200 => DgaPrimitives.neutral700;
  @override
  Color get backgroundPrimary50 =>
      DgaPrimitives.saFlag600Primary.withValues(alpha: 0.1);
  @override
  Color get backgroundPrimary25 => DgaPrimitives.saFlag950;
  @override
  Color get backgroundSecondary50 => DgaPrimitives.neutral800;
  @override
  Color get backgroundSecondary25 => DgaPrimitives.neutral900;
  @override
  Color get backgroundTertiary50 => DgaPrimitives.neutral800;
  @override
  Color get backgroundTertiary25 => DgaPrimitives.neutral900;
  @override
  Color get backgroundSuccess => DgaPrimitives.green600;
  @override
  Color get backgroundSuccess50 =>
      DgaPrimitives.green700.withValues(alpha: 0.2);
  @override
  Color get backgroundSuccess25 =>
      DgaPrimitives.green700.withValues(alpha: 0.1);
  @override
  Color get backgroundInfo => DgaPrimitives.blue600;
  @override
  Color get backgroundInfo50 => DgaPrimitives.blue700.withValues(alpha: 0.2);
  @override
  Color get backgroundInfo25 => DgaPrimitives.blue700.withValues(alpha: 0.1);
  @override
  Color get backgroundWarning => DgaPrimitives.yellow600;
  @override
  Color get backgroundWarning50 =>
      DgaPrimitives.yellow700.withValues(alpha: 0.2);
  @override
  Color get backgroundWarning25 =>
      DgaPrimitives.yellow700.withValues(alpha: 0.1);
  @override
  Color get backgroundError => DgaPrimitives.red600;
  @override
  Color get backgroundError50 => DgaPrimitives.red700.withValues(alpha: 0.2);
  @override
  Color get backgroundError25 => DgaPrimitives.red700.withValues(alpha: 0.1);
  @override
  Color get backgroundSaFlag => DgaPrimitives.saFlag600Primary;
  @override
  Color get backgroundSaFlag50 => DgaPrimitives.neutral800;
  @override
  Color get backgroundSaFlag25 => DgaPrimitives.neutral900;
  @override
  Color get backgroundNotificationWhite => DgaPrimitives.neutral900;
  @override
  Color get backgroundNavHeader => DgaPrimitives.saFlag800;

  // Text
  @override
  Color get textDefault => DgaPrimitives.white;
  @override
  Color get textWhite => DgaPrimitives.black;
  @override
  Color get textPrimary => DgaPrimitives.saFlag400;
  @override
  Color get textPrimarySaFlag => DgaPrimitives.saFlag100;
  @override
  Color get textDisplay => DgaPrimitives.neutral50;
  @override
  Color get textPrimaryParagraph => DgaPrimitives.neutral100;
  @override
  Color get textSecondaryParagraph => DgaPrimitives.neutral200;
  @override
  Color get textOncolorPrimary => DgaPrimitives.white;
  @override
  Color get textOncolorSecondary => DgaPrimitives.black.withValues(alpha: 0.8);
  @override
  Color get textOncolorTertiary => DgaPrimitives.black.withValues(alpha: 0.7);
  @override
  Color get textSuccess => DgaPrimitives.green400;
  @override
  Color get textInfo => DgaPrimitives.blue400;
  @override
  Color get textWarning => DgaPrimitives.yellow400;
  @override
  Color get textError => DgaPrimitives.red400;
  @override
  Color get textPrimaryLight => DgaPrimitives.saFlag400;

  // Global
  @override
  Color get textDefaultDisabled => DgaPrimitives.neutral400;
  @override
  Color get textDefaultOncolorDisabled =>
      DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get globalBorderDisabled => DgaPrimitives.neutral400;
  @override
  Color get backgroundDisabled => DgaPrimitives.neutral700;
  @override
  Color get backgroundDisabledPrimary => DgaPrimitives.saFlag700;
  @override
  Color get backgroundInverseDisabled => DgaPrimitives.neutral700;
  @override
  Color get iconDefaultDisabled => DgaPrimitives.white;
  @override
  Color get iconDefaultOncolorDisabled => DgaPrimitives.white;
  @override
  Color get globalControlDisabled => DgaPrimitives.white.withValues(alpha: 0.3);

  // Border
  @override
  Color get borderWhite => DgaPrimitives.black;
  @override
  Color get borderWhite40 => DgaPrimitives.black.withValues(alpha: 0.4);
  @override
  Color get borderBlack => DgaPrimitives.white;
  @override
  Color get borderPrimary => DgaPrimitives.saFlag300;
  @override
  Color get borderPrimaryLight => DgaPrimitives.green200;
  @override
  Color get borderNeutralPrimary => DgaPrimitives.neutral500;
  @override
  Color get borderNeutralSecondary => DgaPrimitives.neutral700;
  @override
  Color get borderNeutralTertiary => DgaPrimitives.neutral800;
  @override
  Color get borderBackgroundWhite => DgaPrimitives.neutral600;
  @override
  Color get borderBackgroundNeutral => DgaPrimitives.neutral600;
  @override
  Color get borderTransparent10 => DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get borderOncolorTransparent30 =>
      DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get borderSuccess => DgaPrimitives.green500;
  @override
  Color get borderSuccessLight => DgaPrimitives.green200;
  @override
  Color get borderInfo => DgaPrimitives.blue700;
  @override
  Color get borderInfoLight => DgaPrimitives.blue200;
  @override
  Color get borderWarning => DgaPrimitives.yellow700;
  @override
  Color get borderWarningLight => DgaPrimitives.yellow200;
  @override
  Color get borderError => DgaPrimitives.red700;
  @override
  Color get borderErrorLight => DgaPrimitives.red200;
  @override
  Color get borderDisabled => DgaPrimitives.neutral500;

  // Button
  @override
  Color get buttonBackgroundBlackDefault => DgaPrimitives.neutral950;
  @override
  Color get buttonBackgroundBlackHovered => DgaPrimitives.neutral800;
  @override
  Color get buttonBackgroundBlackPressed => DgaPrimitives.neutral600;
  @override
  Color get buttonBackgroundBlackSelected => DgaPrimitives.neutral700;
  @override
  Color get buttonBackgroundBlackFocused => DgaPrimitives.neutral950;
  @override
  Color get buttonBackgroundPrimaryDefault => DgaPrimitives.saFlag600Primary;
  @override
  Color get buttonBackgroundPrimaryHovered => DgaPrimitives.saFlag700;
  @override
  Color get buttonBackgroundPrimaryPressed => DgaPrimitives.saFlag900;
  @override
  Color get buttonBackgroundPrimarySelected => DgaPrimitives.saFlag800;
  @override
  Color get buttonBackgroundPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get buttonBackgroundNeutralDefault => DgaPrimitives.neutral800;
  @override
  Color get buttonBackgroundNeutralHovered => DgaPrimitives.neutral700;
  @override
  Color get buttonBackgroundNeutralPressed => DgaPrimitives.neutral600;
  @override
  Color get buttonBackgroundNeutralSelected => DgaPrimitives.neutral700;
  @override
  Color get buttonBackgroundNeutralFocused => DgaPrimitives.neutral800;
  @override
  Color get buttonBackgroundDangerPrimaryDefault => DgaPrimitives.red600;
  @override
  Color get buttonBackgroundDangerPrimaryHovered => DgaPrimitives.red700;
  @override
  Color get buttonBackgroundDangerPrimaryPressed => DgaPrimitives.red900;
  @override
  Color get buttonBackgroundDangerPrimarySelected => DgaPrimitives.red800;
  @override
  Color get buttonBackgroundDangerPrimaryFocused => DgaPrimitives.red600;
  @override
  Color get buttonLabelDangerPrimaryDefaultOncolor => DgaPrimitives.red200;
  @override
  Color get buttonLabelDangerPrimaryHoveredOncolor => DgaPrimitives.red300;
  @override
  Color get buttonLabelDangerPrimaryPressedOncolor => DgaPrimitives.red400;
  @override
  Color get buttonBackgroundDangerSecondaryDefault => DgaPrimitives.red50;
  @override
  Color get buttonBackgroundDangerSecondaryHovered => DgaPrimitives.red100;
  @override
  Color get buttonBackgroundDangerSecondaryPressed => DgaPrimitives.red200;
  @override
  Color get buttonBackgroundDangerSecondarySelected => DgaPrimitives.red50;
  @override
  Color get buttonBackgroundDangerSecondaryFocused => DgaPrimitives.red50;
  @override
  Color get buttonBackgroundOncolorDefault => DgaPrimitives.black;
  @override
  Color get buttonBackgroundOncolorHovered =>
      DgaPrimitives.black.withValues(alpha: 0.8);
  @override
  Color get buttonBackgroundOncolorPressed =>
      DgaPrimitives.black.withValues(alpha: 0.6);
  @override
  Color get buttonBackgroundOncolorSelected =>
      DgaPrimitives.black.withValues(alpha: 0.7);
  @override
  Color get buttonBackgroundOncolorFocused => DgaPrimitives.black;
  @override
  Color get buttonBackgroundTransparentDefault =>
      DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get buttonBackgroundTransparentHovered =>
      DgaPrimitives.black.withValues(alpha: 0.2);
  @override
  Color get buttonBackgroundTransparentPressed =>
      DgaPrimitives.black.withValues(alpha: 0.4);
  @override
  Color get buttonBackgroundTransparentSelected =>
      DgaPrimitives.black.withValues(alpha: 0.3);
  @override
  Color get buttonBackgroundTransparentFocused =>
      DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get buttonBackgroundDisabledOnColor =>
      DgaPrimitives.black.withValues(alpha: 0.2);
  @override
  Color get buttonLabelTransparentHoveredOnColor => DgaPrimitives.saFlag400;
  @override
  Color get buttonLabelTransparentPressedOnColor => DgaPrimitives.saFlag300;
  @override
  Color get buttonLabelTransparentSelectedOnColor => DgaPrimitives.saFlag400;
  @override
  Color get buttonIconTransparentHoveredOnColor => DgaPrimitives.saFlag400;
  @override
  Color get buttonIconTransparentPressedOnColor => DgaPrimitives.saFlag300;
  @override
  Color get buttonIconTransparentSelectedOnColor => DgaPrimitives.saFlag400;

  // Chip
  @override
  Color get chipBackgroundNeutralDefault => DgaPrimitives.neutral800;
  @override
  Color get chipBackgroundNeutralHovered => DgaPrimitives.neutral600;
  @override
  Color get chipBackgroundNeutralSelected => DgaPrimitives.neutral700;
  @override
  Color get chipBackgroundNeutralFocused => DgaPrimitives.neutral800;
  @override
  Color get chipBackgroundPrimaryFocused => DgaPrimitives.saFlag300;
  @override
  Color get chipBackgroundOnColorDefault => DgaPrimitives.black;
  @override
  Color get chipBackgroundOnColorHovered =>
      DgaPrimitives.black.withValues(alpha: 0.8);
  @override
  Color get chipBackgroundOnColorPressed =>
      DgaPrimitives.black.withValues(alpha: 0.6);
  @override
  Color get chipBackgroundOnColorSelected =>
      DgaPrimitives.black.withValues(alpha: 0.7);
  @override
  Color get chipBackgroundOnColorFocused => DgaPrimitives.black;
  @override
  Color get chipBackgroundOnColorDiabled =>
      DgaPrimitives.black.withValues(alpha: 0.2);

  // Link
  @override
  Color get linkPrimary => DgaPrimitives.saFlag600Primary;
  @override
  Color get linkPrimaryHovered => DgaPrimitives.saFlag400;
  @override
  Color get linkPrimaryPressed => DgaPrimitives.saFlag300;
  @override
  Color get linkPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get linkPrimaryVisited => DgaPrimitives.saFlag800;
  @override
  Color get linkIconPrimaryHovered => DgaPrimitives.saFlag400;
  @override
  Color get linkIconPrimaryPressed => DgaPrimitives.saFlag300;
  @override
  Color get linkIconPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get linkIconPrimaryVisited => DgaPrimitives.saFlag800;
  @override
  Color get linkNeutral => DgaPrimitives.neutral200;
  @override
  Color get linkNeutralHovered => DgaPrimitives.neutral400;
  @override
  Color get linkIconNeutralHovered => DgaPrimitives.neutral400;
  @override
  Color get linkNeutralPressed => DgaPrimitives.neutral500;
  @override
  Color get linkIconNeutralPressed => DgaPrimitives.neutral500;
  @override
  Color get linkNeutralFocused => DgaPrimitives.neutral200;
  @override
  Color get linkIconNeutralFocused => DgaPrimitives.neutral200;
  @override
  Color get linkNeutralVisited => DgaPrimitives.neutral300;
  @override
  Color get linkIconNeutralVisited => DgaPrimitives.neutral300;
  @override
  Color get linkDanger => DgaPrimitives.red600;
  @override
  Color get linkDangerHovered => DgaPrimitives.red700;
  @override
  Color get linkIconDangerHovered => DgaPrimitives.red700;
  @override
  Color get linkDangerPressed => DgaPrimitives.red900;
  @override
  Color get linkIconDangerPressed => DgaPrimitives.red900;
  @override
  Color get linkDangerFocused => DgaPrimitives.red600;
  @override
  Color get linkIconDangerFocused => DgaPrimitives.red600;
  @override
  Color get linkDangerVisited => DgaPrimitives.red800;
  @override
  Color get linkIconDangerVisited => DgaPrimitives.red800;
  @override
  Color get linkOncolor => DgaPrimitives.white;
  @override
  Color get linkOncolorHovered => DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get linkIconOncolorHovered =>
      DgaPrimitives.black.withValues(alpha: 0.8);
  @override
  Color get linkOncolorPressed => DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get linkIconOncolorPressed =>
      DgaPrimitives.black.withValues(alpha: 0.6);
  @override
  Color get linkOncolorFocused => DgaPrimitives.white;
  @override
  Color get linkLinkOncolorFocused => DgaPrimitives.white;
  @override
  Color get linkOncolorVisited => DgaPrimitives.white.withValues(alpha: 0.9);
  @override
  Color get linkIconOncolorVisited =>
      DgaPrimitives.black.withValues(alpha: 0.9);
  @override
  Color get linkOncolorDisabled => DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get linkIconOncolorDisabled =>
      DgaPrimitives.black.withValues(alpha: 0.3);

  // Icon
  @override
  Color get iconOncolor => DgaPrimitives.white;
  @override
  Color get iconDefault => DgaPrimitives.white;
  @override
  Color get iconDefault500 => DgaPrimitives.neutral200;
  @override
  Color get iconDefault400 => DgaPrimitives.neutral500;
  @override
  Color get iconPrimary => DgaPrimitives.saFlag400;
  @override
  Color get iconPrimaryLight => DgaPrimitives.saFlag50;
  @override
  Color get iconPrimary400 => DgaPrimitives.saFlag200;
  @override
  Color get iconNeutral => DgaPrimitives.neutral400;
  @override
  Color get iconNeutralLight => DgaPrimitives.neutral950;
  @override
  Color get iconSecondaryLight => DgaPrimitives.gold50;
  @override
  Color get iconTertiaryLight => DgaPrimitives.lavendar50;
  @override
  Color get iconSuccess => DgaPrimitives.green400;
  @override
  Color get iconSuccessLight => DgaPrimitives.green50;
  @override
  Color get iconInfo => DgaPrimitives.blue400;
  @override
  Color get iconInfoLight => DgaPrimitives.blue50;
  @override
  Color get iconWarning => DgaPrimitives.yellow400;
  @override
  Color get iconWarningLight => DgaPrimitives.yellow50;
  @override
  Color get iconError => DgaPrimitives.red400;
  @override
  Color get iconErrorLight => DgaPrimitives.red50;
  @override
  Color get backgroundWarningLight =>
      DgaPrimitives.yellow700.withValues(alpha: 0.1);
  @override
  Color get backgroundErrorLight => DgaPrimitives.red700.withValues(alpha: 0.1);
  @override
  Color get backgroundBrandLight => DgaPrimitives.saFlag700;
  @override
  Color get backgroundInfoLight => DgaPrimitives.blue700.withValues(alpha: 0.1);
  @override
  Color get backgroundSuccessLight =>
      DgaPrimitives.green700.withValues(alpha: 0.1);
  @override
  Color get unselectedTabIcon => DgaPrimitives.neutral100;

  // Tag
  @override
  Color get tagBackgroundNeutral => DgaPrimitives.saFlag600Primary;
  @override
  Color get tagBackgroundNeutralLight => DgaPrimitives.neutral800;
  @override
  Color get tagBackgroundOnColor => DgaPrimitives.white.withValues(alpha: 0.2);
  @override
  Color get tagTextNeutral => DgaPrimitives.neutral100;
  @override
  Color get tagTextSuccess => DgaPrimitives.green800;
  @override
  Color get tagTextInfo => DgaPrimitives.blue800;
  @override
  Color get tagTextWarning => DgaPrimitives.yellow800;
  @override
  Color get tagTextError => DgaPrimitives.red800;
  @override
  Color get tagIconNeutral => DgaPrimitives.neutral100;
  @override
  Color get tagIconSuccess => DgaPrimitives.green800;
  @override
  Color get tagIconInfo => DgaPrimitives.blue800;
  @override
  Color get tagIconWarning => DgaPrimitives.yellow800;
  @override
  Color get tagIconError => DgaPrimitives.red800;
  @override
  Color get tagBackgroundSuccess => DgaPrimitives.green700;
  @override
  Color get tagBackgroundSuccessLight => DgaPrimitives.green50;
  @override
  Color get tagBackgroundInfo => DgaPrimitives.blue600;
  @override
  Color get tagBackgroundInfoLight => DgaPrimitives.blue50;
  @override
  Color get tagBackgroundWarning => DgaPrimitives.yellow700;
  @override
  Color get tagBackgroundWarningLight => DgaPrimitives.yellow50;
  @override
  Color get tagBackgroundError => DgaPrimitives.red600;
  @override
  Color get tagBackgroundErrorLight => DgaPrimitives.red50;
  @override
  Color get tagBorderNeutral => DgaPrimitives.neutral300;
  @override
  Color get tagBorderNeutralLight => DgaPrimitives.neutral800;
  @override
  Color get tagBorderOnColor => DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get tagBorderSuccess => DgaPrimitives.green700;
  @override
  Color get tagBorderSuccessLight => DgaPrimitives.green200;
  @override
  Color get tagBorderInfo => DgaPrimitives.blue700;
  @override
  Color get tagBorderInfoLight => DgaPrimitives.blue200;
  @override
  Color get tagBorderWarning => DgaPrimitives.red700;
  @override
  Color get tagBorderWarningLight => DgaPrimitives.yellow200;
  @override
  Color get tagBorderError => DgaPrimitives.red700;
  @override
  Color get tagBorderErrorLight => DgaPrimitives.red200;
  @override
  Color get tagDot => DgaPrimitives.white.withValues(alpha: 0.6);

  // Form
  @override
  Color get textFormTitle => DgaPrimitives.white;
  @override
  Color get textFormParagraph => DgaPrimitives.neutral200;
  @override
  Color get fieldTextLabel => DgaPrimitives.white;
  @override
  Color get fieldTextPlaceholder => DgaPrimitives.neutral200;
  @override
  Color get fieldTextHovered => DgaPrimitives.white;
  @override
  Color get fieldTextFocused => DgaPrimitives.neutral100;
  @override
  Color get fieldTextPressed => DgaPrimitives.neutral100;
  @override
  Color get fieldTextFilled => DgaPrimitives.white;
  @override
  Color get fieldTextReadonly => DgaPrimitives.white;
  @override
  Color get fieldTextHelper => DgaPrimitives.neutral200;
  @override
  Color get fieldBackgroundDefault => DgaPrimitives.neutral800;
  @override
  Color get fieldBackgroundLighter => DgaPrimitives.neutral600;
  @override
  Color get fieldBackgroundDarker => DgaPrimitives.neutral800;
  @override
  Color get fieldBackgroundPressed => DgaPrimitives.neutral600;
  @override
  Color get fieldBorderDefault => DgaPrimitives.neutral500;
  @override
  Color get fieldBorderHovered => DgaPrimitives.neutral200;
  @override
  Color get fieldBorderPressed => DgaPrimitives.neutral25;
  @override
  Color get fieldBorderError => DgaPrimitives.red700;
  @override
  Color get optionBackgroundHover => DgaPrimitives.neutral500;
  @override
  Color get optionBackgroundPressed => DgaPrimitives.neutral700;
  @override
  Color get datecellBackgroundDefault => DgaPrimitives.saFlag600Primary;
  @override
  Color get datecellBackgroundHovered => DgaPrimitives.saFlag700;
  @override
  Color get datecellBackgroundPressed => DgaPrimitives.saFlag900;
  @override
  Color get datecellBackgroundFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get datecellTodayBackgroundDefault =>
      DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get datecellTodayBackgroundHovered => DgaPrimitives.neutral700;
  @override
  Color get datecellTodayBackgroundPressed => DgaPrimitives.neutral600;
  @override
  Color get datecellTodayBackgroundFocused =>
      DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get datecellBackgroundDisabled => DgaPrimitives.white;
  @override
  Color get datecellBackground600 => DgaPrimitives.saFlag600Primary;
  @override
  Color get datecellBackground300 => DgaPrimitives.saFlag300;
  @override
  Color get datecellBackground200 => DgaPrimitives.saFlag400;
  @override
  Color get datecellBackground100 => DgaPrimitives.saFlag300;
  @override
  Color get textareaScrollbarBar => DgaPrimitives.neutral600;

  // Controls
  @override
  Color get controlPrimary => DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get controlPrimaryChecked => DgaPrimitives.saFlag600Primary;
  @override
  Color get controlPrimaryHovered => DgaPrimitives.saFlag300;
  @override
  Color get controlPrimaryPressed => DgaPrimitives.saFlag400;
  @override
  Color get controlPrimaryFocused => DgaPrimitives.saFlag600Primary;
  @override
  Color get controlNeutralChecked => DgaPrimitives.neutral600;
  @override
  Color get controlNeutralHovered => DgaPrimitives.neutral400;
  @override
  Color get controlNeutralPressed => DgaPrimitives.neutral400;
  @override
  Color get controlNeutralFocused => DgaPrimitives.neutral600;
  @override
  Color get controlPrimaryReadonly =>
      DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get controlPressed => DgaPrimitives.neutral600;
  @override
  Color get controlRippleEffect => DgaPrimitives.neutral900;
  @override
  Color get controlBorder => DgaPrimitives.neutral400;
  @override
  Color get controlIconHovered => DgaPrimitives.saFlag800;
  @override
  Color get controlIconPressed => DgaPrimitives.saFlag800;
  @override
  Color get controlIconDisabled => DgaPrimitives.neutral400;
  @override
  Color get controlBoarderDisabled =>
      DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get controlDisabled => DgaPrimitives.neutral300;

  // Table
  @override
  Color get tableCellBorder => DgaPrimitives.neutral600;
  @override
  Color get tableCellBorderInverse => DgaPrimitives.white;
  @override
  Color get tableTextHead => DgaPrimitives.neutral300;
  @override
  Color get tableTextBody => DgaPrimitives.white;
  @override
  Color get tableBackgroundDisabled => DgaPrimitives.neutral700;
  @override
  Color get tableBackgroundHoverSelected => DgaPrimitives.neutral900;
  @override
  Color get tableBackgroundHeader => DgaPrimitives.neutral900;
  @override
  Color get tableBackgroundRow => DgaPrimitives.neutral900;
  @override
  Color get tableBackgroundRowSelectedHovered => DgaPrimitives.saFlag50;
  @override
  Color get tableBoarderRowSelectedHovered => DgaPrimitives.neutral100;
  @override
  Color get tableBackgroundRowSelect => DgaPrimitives.saFlag50;
  @override
  Color get tableBackgroundRowHovered => DgaPrimitives.neutral100;
  @override
  Color get tableBackgroundRowAlt => DgaPrimitives.white;

  // Stepper
  @override
  Color get stepperButtonCompleted => DgaPrimitives.green600;
  @override
  Color get stepperButtonCompletedHovered => DgaPrimitives.saFlag700;
  @override
  Color get stepperButtonCurrent => DgaPrimitives.green600;
  @override
  Color get stepperButtonCurrentHovered => DgaPrimitives.saFlag700;
  @override
  Color get stepperButtonUpcomming => DgaPrimitives.neutral600;
  @override
  Color get stepperButtonUpcommingHovered => DgaPrimitives.neutral600;
  @override
  Color get stepperButtonBackground => DgaPrimitives.white;
  @override
  Color get stepperTextPrimary => DgaPrimitives.white;
  @override
  Color get stepperTextSecondary => DgaPrimitives.neutral100;
  @override
  Color get stepperTextTertiary => DgaPrimitives.neutral200;
  @override
  Color get stepperLineCompleted => DgaPrimitives.saFlag600Primary;
  @override
  Color get stepperLineCompletedHovered => DgaPrimitives.saFlag700;
  @override
  Color get stepperLineCurrent => DgaPrimitives.neutral700;
  @override
  Color get stepperLineUpcomming => DgaPrimitives.neutral700;
  @override
  Color get stepperLineUpcommingHovered => DgaPrimitives.neutral700;

  // Tooltip
  @override
  Color get tooltipBackgroundLight => DgaPrimitives.neutral800;
  @override
  Color get tooltipTextHeadingLight => DgaPrimitives.neutral50;
  @override
  Color get tooltipTextParagraphLight => DgaPrimitives.neutral100;
  @override
  Color get tooltipBackgroundDark => DgaPrimitives.white;
  @override
  Color get tooltipTextHeadingDark => DgaPrimitives.neutral800;
  @override
  Color get tooltipTextParagraphDark => DgaPrimitives.neutral700;

  // Charts
  @override
  Color get chartsBlue => DgaPrimitives.blue400;
  @override
  Color get chartsLavendar => DgaPrimitives.lavendar500Primary;
  @override
  Color get chartsGreen => DgaPrimitives.saFlag300;
  @override
  Color get chartsGold => DgaPrimitives.gold400;
  @override
  Color get chartsRed => DgaPrimitives.red400;
  @override
  Color get chartsYellow => DgaPrimitives.yellow400;
  @override
  Color get chartsGreenPrimary200 => DgaPrimitives.saFlag200;

  // Progress Bar
  @override
  Color get progressBarNeutral => DgaPrimitives.neutral700;

  // Alpha
  @override
  Color get alphaWhite0 => DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get alphaWhite10 => DgaPrimitives.black.withValues(alpha: 0.1);
  @override
  Color get alphaWhite20 => DgaPrimitives.black.withValues(alpha: 0.2);
  @override
  Color get alphaWhite30 => DgaPrimitives.black.withValues(alpha: 0.3);
  @override
  Color get alphaWhite40 => DgaPrimitives.black.withValues(alpha: 0.4);
  @override
  Color get alphaWhite50 => DgaPrimitives.black.withValues(alpha: 0.5);
  @override
  Color get alphaWhite60 => DgaPrimitives.black.withValues(alpha: 0.6);
  @override
  Color get alphaWhite70 => DgaPrimitives.black.withValues(alpha: 0.7);
  @override
  Color get alphaWhite80 => DgaPrimitives.black.withValues(alpha: 0.8);
  @override
  Color get alphaWhite90 => DgaPrimitives.black.withValues(alpha: 0.9);
  @override
  Color get alphaWhite100 => DgaPrimitives.black;
  @override
  Color get alphaBlack0 => DgaPrimitives.white.withValues(alpha: 0.1);
  @override
  Color get alphaBlack10 => DgaPrimitives.white.withValues(alpha: 0.1);
  @override
  Color get alphaBlack20 => DgaPrimitives.white.withValues(alpha: 0.2);
  @override
  Color get alphaBlack30 => DgaPrimitives.white.withValues(alpha: 0.3);
  @override
  Color get alphaBlack40 => DgaPrimitives.white.withValues(alpha: 0.4);
  @override
  Color get alphaBlack50 => DgaPrimitives.white.withValues(alpha: 0.5);
  @override
  Color get alphaBlack60 => DgaPrimitives.white.withValues(alpha: 0.6);
  @override
  Color get alphaBlack70 => DgaPrimitives.white.withValues(alpha: 0.7);
  @override
  Color get alphaBlack80 => DgaPrimitives.white.withValues(alpha: 0.8);
  @override
  Color get alphaBlack90 => DgaPrimitives.white.withValues(alpha: 0.9);
  @override
  Color get alphaBlack100 => DgaPrimitives.white;
  @override
  Color get alphaPrimary10 => DgaPrimitives.saFlag700.withValues(alpha: 0.1);
  @override
  Color get alphaPrimary20 => DgaPrimitives.saFlag700.withValues(alpha: 0.2);
  @override
  Color get alphaWarning10 => DgaPrimitives.yellow700.withValues(alpha: 0.1);
  @override
  Color get alphaWarning20 => DgaPrimitives.yellow700.withValues(alpha: 0.2);
  @override
  Color get alphaError10 => DgaPrimitives.red700.withValues(alpha: 0.1);
  @override
  Color get alphaError20 => DgaPrimitives.red700.withValues(alpha: 0.2);
  @override
  Color get alphaInfo10 => DgaPrimitives.blue700.withValues(alpha: 0.1);
  @override
  Color get alphaInfo20 => DgaPrimitives.blue700.withValues(alpha: 0.2);
  @override
  Color get alphaSuccess10 => DgaPrimitives.green700.withValues(alpha: 0.1);
  @override
  Color get alphaSuccess20 => DgaPrimitives.green700.withValues(alpha: 0.2);
}
