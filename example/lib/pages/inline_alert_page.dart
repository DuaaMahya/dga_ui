import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class InlineAlertPage extends StatelessWidget {
  const InlineAlertPage({super.key});

  static const _severities = [
    (DgaAlertSeverity.neutral, 'Neutral'),
    (DgaAlertSeverity.info, 'Info'),
    (DgaAlertSeverity.error, 'Error'),
    (DgaAlertSeverity.warning, 'Warning'),
    (DgaAlertSeverity.success, 'Success'),
  ];

  Widget _alert(
    DgaAlertSeverity severity,
    String label, {
    DgaInlineAlertBackground background = DgaInlineAlertBackground.white,
    List<Widget> actions = const [],
    bool dismissible = true,
    bool? mobile,
  }) => DgaInlineAlert(
    title: '$label — notification/alert message title',
    description:
        'When a Notification/Alert needs a further detailed explanation, '
        'it goes here.',
    severity: severity,
    background: background,
    actions: actions,
    dismissible: dismissible,
    mobile: mobile,
    // Uncontrolled dismissal so the gallery cards actually disappear.
    onDismiss: null,
  );

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaInlineAlert',
    children: [
      sectionHeader(context, 'White background — all severities'),
      for (final (severity, label) in _severities)
        sectionRow(_alert(severity, label)),

      sectionHeader(context, 'Color background — all severities'),
      for (final (severity, label) in _severities)
        sectionRow(
          _alert(severity, label, background: DgaInlineAlertBackground.color),
        ),

      sectionHeader(context, 'With actions'),
      sectionRow(
        _alert(
          DgaAlertSeverity.info,
          'Info',
          background: DgaInlineAlertBackground.color,
          actions: [
            DgaButton.secondarySolid(onPressed: () {}, label: 'Button'),
            DgaButton.transparent(onPressed: () {}, label: 'Button'),
          ],
        ),
      ),

      sectionHeader(context, 'Not dismissible / no icon'),
      sectionRow(
        DgaInlineAlert(
          title: 'This one cannot be dismissed',
          description: 'No close button, and the status glyph is hidden.',
          severity: DgaAlertSeverity.warning,
          background: DgaInlineAlertBackground.color,
          dismissible: false,
          showIcon: false,
        ),
      ),

      sectionHeader(
        context,
        'Mobile layout (forced) — accent bar moves to the top edge, icon + '
        'close share a row, actions stack and keep their own width',
      ),
      sectionRow(
        SizedBox(
          width: 343,
          child: _alert(
            DgaAlertSeverity.success,
            'Success',
            background: DgaInlineAlertBackground.color,
            mobile: true,
            actions: [
              // Wrap to opt into full width…
              SizedBox(
                width: double.infinity,
                child: DgaButton.secondarySolid(
                  onPressed: () {},
                  label: 'Full-width',
                ),
              ),
              // …or leave it to size itself and sit centred.
              DgaButton.transparent(onPressed: () {}, label: 'Natural width'),
            ],
          ),
        ),
      ),
    ],
  );
}
