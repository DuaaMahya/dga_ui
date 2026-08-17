import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class NotificationToastPage extends StatelessWidget {
  const NotificationToastPage({super.key});

  static const _severities = [
    (DgaAlertSeverity.neutral, 'Neutral'),
    (DgaAlertSeverity.info, 'Info'),
    (DgaAlertSeverity.error, 'Error'),
    (DgaAlertSeverity.warning, 'Warning'),
    (DgaAlertSeverity.success, 'Success'),
  ];

  void _fire(
    BuildContext context,
    DgaToastPlacement placement, {
    DgaAlertSeverity severity = DgaAlertSeverity.info,
  }) {
    DgaNotificationToast.show(
      context,
      severity: severity,
      title: 'Notification/Alert message title',
      description:
          'When a Notification/Alert needs a further detailed explanation, '
          'it goes here.',
      placement: placement,
    );
  }

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaNotificationToast',
    children: [
      sectionHeader(context, 'Live — fire a toast at each placement'),
      sectionRow(
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final placement in DgaToastPlacement.values)
              DgaButton.secondaryOutline(
                onPressed: () => _fire(context, placement),
                label: placement.name,
              ),
          ],
        ),
      ),
      sectionRow(
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (severity, label) in _severities)
              DgaButton.subtle(
                onPressed: () => _fire(
                  context,
                  DgaToastPlacement.topCenter,
                  severity: severity,
                ),
                label: label,
              ),
          ],
        ),
      ),
      sectionRow(
        DgaButton.primary(
          onPressed: () {
            // One shows at a time; the rest queue and play in sequence.
            for (final (severity, label) in _severities.take(3)) {
              DgaNotificationToast.show(
                context,
                severity: severity,
                title: '$label toast',
                description: 'Queued toasts play one after another.',
                duration: const Duration(seconds: 2),
              );
            }
          },
          label: 'Fire 3 in a row (they queue)',
        ),
      ),
      sectionRow(
        DgaButton.secondarySolid(
          onPressed: () {
            final handle = DgaNotificationToast.show(
              context,
              severity: DgaAlertSeverity.warning,
              title: 'Dismissing in 1 second',
              description: 'Shows the handle dismissing a toast early.',
              duration: Duration.zero, // no auto-dismiss
            );
            Future<void>.delayed(const Duration(seconds: 1), handle.dismiss);
          },
          label: 'Dismiss early via handle',
        ),
      ),

      sectionHeader(context, 'Static widgets — all severities'),
      for (final (severity, label) in _severities)
        sectionRow(
          DgaNotificationToast(
            severity: severity,
            title: '$label — notification/alert message title',
            description:
                'When a Notification/Alert needs a further detailed '
                'explanation, it goes here.',
            actions: [
              DgaButton.secondarySolid(onPressed: () {}, label: 'Button'),
              DgaButton.transparent(onPressed: () {}, label: 'Button'),
            ],
          ),
        ),

      sectionHeader(
        context,
        'Mobile layout (forced) — accent moves to the top edge, and each '
        'action keeps its own width',
      ),
      sectionRow(
        SizedBox(
          width: 343,
          child: DgaNotificationToast(
            severity: DgaAlertSeverity.info,
            title: 'Notification/Alert message title',
            description:
                'When a Notification/Alert needs a further detailed '
                'explanation, it goes here.',
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
