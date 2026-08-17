import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {
  bool _a = false;
  bool _b = true;
  bool _c = true;

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaSwitch',
    children: [
      sectionHeader(context, 'Basic (tap to toggle)'),
      sectionRow(
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            DgaSwitch(value: _a, onChanged: (v) => setState(() => _a = v)),
            DgaSwitch(value: _b, onChanged: (v) => setState(() => _b = v)),
            const DgaSwitch(value: false, onChanged: null, disabled: true),
            const DgaSwitch(value: true, onChanged: null, disabled: true),
          ],
        ),
      ),
      sectionHeader(context, 'With label + description'),
      sectionRow(
        SizedBox(
          width: 360,
          child: DgaSwitch(
            value: _c,
            onChanged: (v) => setState(() => _c = v),
            label: 'Email notifications',
            description: 'Receive product updates and announcements by email.',
          ),
        ),
      ),
      sectionHeader(context, 'With error'),
      sectionRow(
        SizedBox(
          width: 360,
          child: DgaSwitch(
            value: _a,
            onChanged: (v) => setState(() => _a = v),
            label: 'Accept terms',
            errorText: 'You must enable this to continue.',
          ),
        ),
      ),
    ],
  );
}
