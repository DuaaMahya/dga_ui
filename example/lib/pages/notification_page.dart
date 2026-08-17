import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaNotification',
    children: [
      sectionHeader(context, "Notifications - Neutral"),
      sectionRow(
        DgaNotification(
          type: DgaNotificationType.neutral,
          leadText: "Important:",
          helperText:
              "This is a very important banner message that requires attention",
        ),
      ),
      sectionHeader(context, "Notifications - Critical"),
      sectionRow(
        DgaNotification(
          type: DgaNotificationType.error,
          leadText: "Important:",
          helperText:
              "This is a very important banner message that requires attention",
        ),
      ),
      sectionHeader(context, "Notifications - Warning"),
      sectionRow(
        DgaNotification(
          type: DgaNotificationType.warning,
          leadText: "Important:",
          helperText:
              "This is a very important banner message that requires attention",
        ),
      ),
      sectionHeader(context, "Notifications - Success"),
      sectionRow(
        DgaNotification(
          type: DgaNotificationType.success,
          leadText: "Important:",
          helperText:
              "This is a very important banner message that requires attention",
        ),
      ),
      sectionHeader(context, "Notifications - Info"),
      sectionRow(
        DgaNotification(
          type: DgaNotificationType.info,
          leadText: "Important:",
          helperText:
              "This is a very important banner message that requires attention",
        ),
      ),
      sectionHeader(context, "Notification with actions"),
      sectionRow(
        DgaNotification(
          type: DgaNotificationType.neutral,
          dismissable: false,
          hasIcon: false,
          helperText:
              "This is a very important banner message that requires attention",
          action: DgaButton.neutral(label: "Action", onPressed: () {}),
        ),
      ),
    ],
  );
}
