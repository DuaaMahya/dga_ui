import 'package:flutter/material.dart';

import '../../theme/dga_spacing.dart';
import '../../theme/dga_theme.dart';
import '../../theme/dga_typography.dart';

/// Shared layout for a form control (switch/radio) with an optional
/// title + description + error message beside it. When all three are null,
/// the [control] is returned bare.
class DgaControlTile extends StatelessWidget {
  const DgaControlTile({
    super.key,
    required this.control,
    this.label,
    this.description,
    this.errorText,
    this.onTap,
    this.enabled = true,
  });

  final Widget control;
  final String? label;
  final String? description;
  final String? errorText;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (label == null && description == null && errorText == null) {
      return control;
    }
    final c = DgaTheme.of(context).colors;
    final labelColor = enabled ? c.textDefault : c.textDefaultDisabled;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label!,
            style: DgaTypography.textMd.medium.copyWith(color: labelColor),
          ),
        if (description != null) ...[
          const SizedBox(height: DgaSpacing.xxs),
          Text(
            description!,
            style: DgaTypography.textSm.regular.copyWith(
              color: c.textSecondaryParagraph,
            ),
          ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: DgaSpacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 16, color: c.textError),
              const SizedBox(width: DgaSpacing.md),
              Flexible(
                child: Text(
                  errorText!,
                  style: DgaTypography.textSm.regular.copyWith(
                    color: c.textError,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        control,
        const SizedBox(width: DgaSpacing.lg),
        Expanded(child: text),
      ],
    );

    return onTap == null
        ? row
        : InkWell(onTap: enabled ? onTap : null, child: row);
  }
}
