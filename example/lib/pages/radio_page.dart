import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  String _group = 'a';

  Widget _radio(
    String value,
    String label, {
    DgaRadioStyle style = DgaRadioStyle.primary,
  }) => DgaRadio<String>(
    value: value,
    groupValue: _group,
    onChanged: (v) => setState(() => _group = v!),
    label: label,
    style: style,
  );

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaRadio',
    children: [
      sectionHeader(context, 'Primary style'),
      sectionRow(
        SizedBox(
          width: 360,
          child: Column(
            children: [
              _radio('a', 'Option A'),
              const SizedBox(height: 12),
              _radio('b', 'Option B'),
              const SizedBox(height: 12),
              _radio('c', 'Option C'),
            ],
          ),
        ),
      ),
      sectionHeader(context, 'Neutral style'),
      sectionRow(
        SizedBox(
          width: 360,
          child: Column(
            children: [
              _radio('a', 'Neutral A', style: DgaRadioStyle.neutral),
              const SizedBox(height: 12),
              _radio('b', 'Neutral B', style: DgaRadioStyle.neutral),
            ],
          ),
        ),
      ),
      sectionHeader(context, 'With description + disabled/read-only'),
      sectionRow(
        SizedBox(
          width: 360,
          child: Column(
            children: [
              DgaRadio<String>(
                value: 'x',
                groupValue: _group,
                onChanged: (v) => setState(() => _group = v!),
                label: 'Standard shipping',
                description: 'Arrives in 5–7 business days.',
              ),
              const SizedBox(height: 12),
              const DgaRadio<String>(
                value: 'y',
                groupValue: 'z',
                onChanged: null,
                label: 'Disabled option',
                disabled: true,
              ),
              const SizedBox(height: 12),
              const DgaRadio<String>(
                value: 'r',
                groupValue: 'r',
                onChanged: null,
                label: 'Read-only (selected)',
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
