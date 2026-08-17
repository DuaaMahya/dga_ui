import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DgaSpacing', () {
    test('matches Foundations values verbatim', () {
      expect(DgaSpacing.none, 0);
      expect(DgaSpacing.xs, 4);
      expect(DgaSpacing.md, 8);
      expect(DgaSpacing.lg, 12);
      expect(DgaSpacing.xl, 16);
      expect(DgaSpacing.xl2, 20);
      expect(DgaSpacing.xl3, 24);
      expect(DgaSpacing.xl4, 32);
      expect(DgaSpacing.xl6, 48);
      expect(DgaSpacing.xl7, 64);
      expect(DgaSpacing.xl8, 80);
    });
  });

  group('DgaRadius', () {
    test('matches Foundations values verbatim', () {
      expect(DgaRadius.none, 0);
      expect(DgaRadius.xs, 2);
      expect(DgaRadius.sm, 4);
      expect(DgaRadius.md, 8);
      expect(DgaRadius.lg, 16);
      expect(DgaRadius.xl, 24);
      expect(DgaRadius.full, 9999);
    });
  });

  group('DgaPrimitives', () {
    test('brand + neutral scale match the official Colors export', () {
      expect(DgaPrimitives.saFlag600Primary, const Color(0xFF1B8354));
      expect(DgaPrimitives.saFlag700, const Color(0xFF166A45));
      expect(DgaPrimitives.saFlag900, const Color(0xFF104631));
      expect(DgaPrimitives.neutral100, const Color(0xFFF3F4F6));
      expect(DgaPrimitives.neutral950, const Color(0xFF0D121C));
    });

    test('red (error) scale matches the official Colors export', () {
      expect(DgaPrimitives.red500, const Color(0xFFF04438));
      expect(DgaPrimitives.red600, const Color(0xFFD92D20));
      expect(DgaPrimitives.red800, const Color(0xFF912018));
    });

    test('dark-mode neutral grays match the official Colors export', () {
      expect(DgaPrimitives.neutral400, const Color(0xFF9DA4AE));
      expect(DgaPrimitives.neutral700, const Color(0xFF384250));
      expect(DgaPrimitives.neutral950, const Color(0xFF0D121C));
    });
  });

  group('DgaSemanticColors — light', () {
    final light = const DgaSemanticColors.light();

    test('semantic tokens resolve to the correct primitives', () {
      expect(
        light.buttonBackgroundPrimaryDefault,
        DgaPrimitives.saFlag600Primary,
      );
      expect(light.buttonBackgroundPrimaryHovered, DgaPrimitives.saFlag700);
      expect(light.buttonBackgroundPrimaryPressed, DgaPrimitives.saFlag900);
      expect(light.buttonBackgroundDangerPrimaryDefault, DgaPrimitives.red600);
      expect(light.backgroundDisabled, DgaPrimitives.neutral200);
      expect(light.textDefaultDisabled, DgaPrimitives.neutral400);
    });

    test(
      'Neutral (black) button stays a dark fill; Neutral-family button is the soft light-fill',
      () {
        // "Neutral"/black button background is mode-independent per Figma.
        expect(light.buttonBackgroundBlackDefault, DgaPrimitives.neutral950);
        // Secondary-Solid (Figma's button-background-neutral-*) is the soft light button.
        expect(light.buttonBackgroundNeutralDefault, DgaPrimitives.neutral100);
      },
    );
  });

  group('DgaSemanticColors — dark', () {
    final dark = const DgaSemanticColors.dark();
    final light = const DgaSemanticColors.light();

    test('brand green is mode-independent', () {
      expect(
        dark.buttonBackgroundPrimaryDefault,
        light.buttonBackgroundPrimaryDefault,
        reason: 'SA-Flag brand green must not change between modes',
      );
      expect(
        dark.buttonBackgroundPrimaryDefault,
        DgaPrimitives.saFlag600Primary,
      );
    });

    test('background/text swap for dark', () {
      expect(dark.backgroundBody, isNot(equals(light.backgroundBody)));
      expect(dark.textDefault, isNot(equals(light.textDefault)));
      expect(dark.backgroundBody, DgaPrimitives.neutral900);
    });

    test('every getter is reachable (no missing overrides)', () {
      // Reading each getter proves the impl is complete and doesn't throw
      // on any semantic slot. Fails at compile time if we forgot one, but
      // catches accidental UnimplementedError()s at runtime too.
      final all = <Color>[
        dark.backgroundWhite,
        dark.backgroundBody,
        dark.backgroundMenu,
        dark.backgroundCard,
        dark.surfaceOncolor,
        dark.backgroundBlack,
        dark.backgroundNeutral800,
        dark.backgroundNeutral400,
        dark.backgroundNeutral300,
        dark.backgroundNeutral200,
        dark.backgroundNeutral100,
        dark.backgroundNeutral50,
        dark.backgroundNeutral25,
        dark.backgroundPrimary,
        dark.backgroundPrimary400,
        dark.backgroundPrimary200,
        dark.backgroundPrimary50,
        dark.backgroundPrimary25,
        dark.backgroundSecondary50,
        dark.backgroundSecondary25,
        dark.backgroundTertiary50,
        dark.backgroundTertiary25,
        dark.backgroundSuccess,
        dark.backgroundSuccess50,
        dark.backgroundSuccess25,
        dark.backgroundInfo,
        dark.backgroundInfo50,
        dark.backgroundInfo25,
        dark.backgroundWarning,
        dark.backgroundWarning50,
        dark.backgroundWarning25,
        dark.backgroundError,
        dark.backgroundError50,
        dark.backgroundError25,
        dark.backgroundSaFlag,
        dark.backgroundSaFlag50,
        dark.backgroundSaFlag25,
        dark.backgroundNotificationWhite,
        dark.backgroundNavHeader,
        dark.textDefault,
        dark.textPrimary,
        dark.textPrimarySaFlag,
        dark.textDisplay,
        dark.textPrimaryParagraph,
        dark.textSecondaryParagraph,
        dark.textOncolorPrimary,
        dark.textOncolorSecondary,
        dark.textOncolorTertiary,
        dark.textSuccess,
        dark.textInfo,
        dark.textWarning,
        dark.textError,
        dark.textPrimaryLight,
        dark.textDefaultDisabled,
        dark.textDefaultOncolorDisabled,
        dark.globalBorderDisabled,
        dark.backgroundDisabled,
        dark.backgroundDisabledPrimary,
        dark.backgroundInverseDisabled,
        dark.iconDefaultDisabled,
        dark.iconDefaultOncolorDisabled,
        dark.globalControlDisabled,
        dark.borderWhite,
        dark.borderWhite40,
        dark.borderBlack,
        dark.borderPrimary,
        dark.borderPrimaryLight,
        dark.borderNeutralPrimary,
        dark.borderNeutralSecondary,
        dark.borderNeutralTertiary,
        dark.borderBackgroundWhite,
        dark.borderBackgroundNeutral,
        dark.borderTransparent10,
        dark.borderOncolorTransparent30,
        dark.borderSuccess,
        dark.borderSuccessLight,
        dark.borderInfo,
        dark.borderInfoLight,
        dark.borderWarning,
        dark.borderWarningLight,
        dark.borderError,
        dark.borderErrorLight,
        dark.borderDisabled,
        dark.buttonBackgroundBlackDefault,
        dark.buttonBackgroundBlackHovered,
        dark.buttonBackgroundBlackPressed,
        dark.buttonBackgroundBlackSelected,
        dark.buttonBackgroundBlackFocused,
        dark.buttonBackgroundPrimaryDefault,
        dark.buttonBackgroundPrimaryHovered,
        dark.buttonBackgroundPrimaryPressed,
        dark.buttonBackgroundPrimarySelected,
        dark.buttonBackgroundPrimaryFocused,
        dark.buttonBackgroundNeutralDefault,
        dark.buttonBackgroundNeutralHovered,
        dark.buttonBackgroundNeutralPressed,
        dark.buttonBackgroundNeutralSelected,
        dark.buttonBackgroundNeutralFocused,
        dark.buttonBackgroundDangerPrimaryDefault,
        dark.buttonBackgroundDangerPrimaryHovered,
        dark.buttonBackgroundDangerPrimaryPressed,
        dark.buttonBackgroundDangerPrimarySelected,
        dark.buttonBackgroundDangerPrimaryFocused,
        dark.buttonLabelDangerPrimaryDefaultOncolor,
        dark.buttonLabelDangerPrimaryHoveredOncolor,
        dark.buttonLabelDangerPrimaryPressedOncolor,
        dark.buttonBackgroundDangerSecondaryDefault,
        dark.buttonBackgroundDangerSecondaryHovered,
        dark.buttonBackgroundDangerSecondaryPressed,
        dark.buttonBackgroundDangerSecondarySelected,
        dark.buttonBackgroundDangerSecondaryFocused,
        dark.buttonBackgroundOncolorDefault,
        dark.buttonBackgroundOncolorHovered,
        dark.buttonBackgroundOncolorPressed,
        dark.buttonBackgroundOncolorSelected,
        dark.buttonBackgroundOncolorFocused,
        dark.buttonBackgroundTransparentDefault,
        dark.buttonBackgroundTransparentHovered,
        dark.buttonBackgroundTransparentPressed,
        dark.buttonBackgroundTransparentSelected,
        dark.buttonBackgroundTransparentFocused,
        dark.buttonBackgroundDisabledOnColor,
        dark.buttonLabelTransparentHoveredOnColor,
        dark.buttonLabelTransparentPressedOnColor,
        dark.buttonLabelTransparentSelectedOnColor,
        dark.buttonIconTransparentHoveredOnColor,
        dark.buttonIconTransparentPressedOnColor,
        dark.buttonIconTransparentSelectedOnColor,
        dark.chipBackgroundNeutralDefault,
        dark.chipBackgroundNeutralHovered,
        dark.chipBackgroundNeutralSelected,
        dark.chipBackgroundNeutralFocused,
        dark.chipBackgroundPrimaryFocused,
        dark.chipBackgroundOnColorDefault,
        dark.chipBackgroundOnColorHovered,
        dark.chipBackgroundOnColorPressed,
        dark.chipBackgroundOnColorSelected,
        dark.chipBackgroundOnColorFocused,
        dark.chipBackgroundOnColorDiabled,
        dark.linkPrimary,
        dark.linkPrimaryHovered,
        dark.linkPrimaryPressed,
        dark.linkPrimaryFocused,
        dark.linkPrimaryVisited,
        dark.linkIconPrimaryHovered,
        dark.linkIconPrimaryPressed,
        dark.linkIconPrimaryFocused,
        dark.linkIconPrimaryVisited,
        dark.linkNeutral,
        dark.linkNeutralHovered,
        dark.linkIconNeutralHovered,
        dark.linkNeutralPressed,
        dark.linkIconNeutralPressed,
        dark.linkNeutralFocused,
        dark.linkIconNeutralFocused,
        dark.linkNeutralVisited,
        dark.linkIconNeutralVisited,
        dark.linkDanger,
        dark.linkDangerHovered,
        dark.linkIconDangerHovered,
        dark.linkDangerPressed,
        dark.linkIconDangerPressed,
        dark.linkDangerFocused,
        dark.linkIconDangerFocused,
        dark.linkDangerVisited,
        dark.linkIconDangerVisited,
        dark.linkOncolor,
        dark.linkOncolorHovered,
        dark.linkIconOncolorHovered,
        dark.linkOncolorPressed,
        dark.linkIconOncolorPressed,
        dark.linkOncolorFocused,
        dark.linkLinkOncolorFocused,
        dark.linkOncolorVisited,
        dark.linkIconOncolorVisited,
        dark.linkOncolorDisabled,
        dark.linkIconOncolorDisabled,
        dark.iconOncolor,
        dark.iconDefault,
        dark.iconDefault500,
        dark.iconDefault400,
        dark.iconPrimary,
        dark.iconPrimaryLight,
        dark.iconPrimary400,
        dark.iconNeutral,
        dark.iconNeutralLight,
        dark.iconSecondaryLight,
        dark.iconTertiaryLight,
        dark.iconSuccess,
        dark.iconSuccessLight,
        dark.iconInfo,
        dark.iconInfoLight,
        dark.iconWarning,
        dark.iconWarningLight,
        dark.iconError,
        dark.iconErrorLight,
        dark.backgroundWarningLight,
        dark.backgroundErrorLight,
        dark.backgroundBrandLight,
        dark.backgroundInfoLight,
        dark.backgroundSuccessLight,
        dark.unselectedTabIcon,
        dark.tagBackgroundNeutral,
        dark.tagBackgroundNeutralLight,
        dark.tagBackgroundOnColor,
        dark.tagTextNeutral,
        dark.tagTextSuccess,
        dark.tagTextInfo,
        dark.tagTextWarning,
        dark.tagTextError,
        dark.tagIconNeutral,
        dark.tagIconSuccess,
        dark.tagIconInfo,
        dark.tagIconWarning,
        dark.tagIconError,
        dark.tagBackgroundSuccess,
        dark.tagBackgroundSuccessLight,
        dark.tagBackgroundInfo,
        dark.tagBackgroundInfoLight,
        dark.tagBackgroundWarning,
        dark.tagBackgroundWarningLight,
        dark.tagBackgroundError,
        dark.tagBackgroundErrorLight,
        dark.tagBorderNeutral,
        dark.tagBorderNeutralLight,
        dark.tagBorderOnColor,
        dark.tagBorderSuccess,
        dark.tagBorderSuccessLight,
        dark.tagBorderInfo,
        dark.tagBorderInfoLight,
        dark.tagBorderWarning,
        dark.tagBorderWarningLight,
        dark.tagBorderError,
        dark.tagBorderErrorLight,
        dark.tagDot,
        dark.textFormTitle,
        dark.textFormParagraph,
        dark.fieldTextLabel,
        dark.fieldTextPlaceholder,
        dark.fieldTextHovered,
        dark.fieldTextFocused,
        dark.fieldTextPressed,
        dark.fieldTextFilled,
        dark.fieldTextReadonly,
        dark.fieldTextHelper,
        dark.fieldBackgroundDefault,
        dark.fieldBackgroundLighter,
        dark.fieldBackgroundDarker,
        dark.fieldBackgroundPressed,
        dark.fieldBorderDefault,
        dark.fieldBorderHovered,
        dark.fieldBorderPressed,
        dark.fieldBorderError,
        dark.optionBackgroundHover,
        dark.optionBackgroundPressed,
        dark.datecellBackgroundDefault,
        dark.datecellBackgroundHovered,
        dark.datecellBackgroundPressed,
        dark.datecellBackgroundFocused,
        dark.datecellTodayBackgroundDefault,
        dark.datecellTodayBackgroundHovered,
        dark.datecellTodayBackgroundPressed,
        dark.datecellTodayBackgroundFocused,
        dark.datecellBackgroundDisabled,
        dark.datecellBackground600,
        dark.datecellBackground300,
        dark.datecellBackground200,
        dark.datecellBackground100,
        dark.textareaScrollbarBar,
        dark.controlPrimary,
        dark.controlPrimaryChecked,
        dark.controlPrimaryHovered,
        dark.controlPrimaryPressed,
        dark.controlPrimaryFocused,
        dark.controlNeutralChecked,
        dark.controlNeutralHovered,
        dark.controlNeutralPressed,
        dark.controlNeutralFocused,
        dark.controlPrimaryReadonly,
        dark.controlPressed,
        dark.controlRippleEffect,
        dark.controlBorder,
        dark.controlIconHovered,
        dark.controlIconPressed,
        dark.controlIconDisabled,
        dark.controlBoarderDisabled,
        dark.controlDisabled,
        dark.tableCellBorder,
        dark.tableCellBorderInverse,
        dark.tableTextHead,
        dark.tableTextBody,
        dark.tableBackgroundDisabled,
        dark.tableBackgroundHoverSelected,
        dark.tableBackgroundHeader,
        dark.tableBackgroundRow,
        dark.tableBackgroundRowSelectedHovered,
        dark.tableBoarderRowSelectedHovered,
        dark.tableBackgroundRowSelect,
        dark.tableBackgroundRowHovered,
        dark.tableBackgroundRowAlt,
        dark.stepperButtonCompleted,
        dark.stepperButtonCompletedHovered,
        dark.stepperButtonCurrent,
        dark.stepperButtonCurrentHovered,
        dark.stepperButtonUpcomming,
        dark.stepperButtonUpcommingHovered,
        dark.stepperButtonBackground,
        dark.stepperTextPrimary,
        dark.stepperTextSecondary,
        dark.stepperTextTertiary,
        dark.stepperLineCompleted,
        dark.stepperLineCompletedHovered,
        dark.stepperLineCurrent,
        dark.stepperLineUpcomming,
        dark.stepperLineUpcommingHovered,
        dark.tooltipBackgroundLight,
        dark.tooltipTextHeadingLight,
        dark.tooltipTextParagraphLight,
        dark.tooltipBackgroundDark,
        dark.tooltipTextHeadingDark,
        dark.tooltipTextParagraphDark,
        dark.chartsBlue,
        dark.chartsLavendar,
        dark.chartsGreen,
        dark.chartsGold,
        dark.chartsRed,
        dark.chartsYellow,
        dark.chartsGreenPrimary200,
        dark.progressBarNeutral,
        dark.alphaWhite0,
        dark.alphaWhite10,
        dark.alphaWhite20,
        dark.alphaWhite30,
        dark.alphaWhite40,
        dark.alphaWhite50,
        dark.alphaWhite60,
        dark.alphaWhite70,
        dark.alphaWhite80,
        dark.alphaWhite90,
        dark.alphaWhite100,
        dark.alphaBlack0,
        dark.alphaBlack10,
        dark.alphaBlack20,
        dark.alphaBlack30,
        dark.alphaBlack40,
        dark.alphaBlack50,
        dark.alphaBlack60,
        dark.alphaBlack70,
        dark.alphaBlack80,
        dark.alphaBlack90,
        dark.alphaBlack100,
        dark.alphaPrimary10,
        dark.alphaPrimary20,
        dark.alphaWarning10,
        dark.alphaWarning20,
        dark.alphaError10,
        dark.alphaError20,
        dark.alphaInfo10,
        dark.alphaInfo20,
        dark.alphaSuccess10,
        dark.alphaSuccess20,
      ];
      expect(all.length, 361);
      for (final c in all) {
        expect(c, isNotNull);
      }
    });
  });

  group('DgaThemeData', () {
    test('.light() and .dark() are not equal', () {
      expect(
        const DgaThemeData.light(),
        isNot(equals(const DgaThemeData.dark())),
      );
    });

    test('.light() equals another .light()', () {
      expect(const DgaThemeData.light(), equals(const DgaThemeData.light()));
    });
  });

  group('DgaTypography', () {
    test('font family + text ramps match Foundations', () {
      expect(DgaTypography.fontFamily, 'IBM Plex Sans Arabic');
      expect(DgaTypography.textXs.size, 12);
      expect(DgaTypography.textXs.lineHeight, 18);
      expect(DgaTypography.textSm.size, 14);
      expect(DgaTypography.textSm.lineHeight, 20);
      expect(DgaTypography.textMd.size, 16);
      expect(DgaTypography.textMd.lineHeight, 24);
      expect(DgaTypography.textLg.size, 18);
      expect(DgaTypography.textLg.lineHeight, 28);
    });

    test('display ramp letter-spacing matches Foundations', () {
      expect(DgaTypography.displayXl.letterSpacing, -2);
      expect(DgaTypography.displaySm.letterSpacing, 0);
    });
  });
}
