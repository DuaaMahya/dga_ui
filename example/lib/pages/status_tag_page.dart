import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class StatusTagPage extends StatelessWidget {
  const StatusTagPage({super.key});

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaStatusTag',
    children: [
      for (final status in DgaStatusTagStatus.values) ...[
        sectionHeader(context, status.name),
        for (final size in DgaStatusTagSize.values)
          sectionRow(
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in DgaStatusTagColor.values)
                  DgaStatusTag(
                    label: '${c.name} (${size.name})',
                    type: c,
                    status: status,
                    size: size,
                  ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    ],
  );
}
