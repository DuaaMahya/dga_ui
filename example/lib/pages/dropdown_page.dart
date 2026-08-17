import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class DropdownPage extends StatefulWidget {
  const DropdownPage({super.key});

  @override
  State<DropdownPage> createState() => _DropdownPageState();
}

class _DropdownPageState extends State<DropdownPage> {
  String? _city;

  static const _cities = [
    DgaDropdownEntry(value: 'ry', label: 'Riyadh'),
    DgaDropdownEntry(value: 'jd', label: 'Jeddah'),
    DgaDropdownEntry(value: 'dm', label: 'Dammam'),
    DgaDropdownEntry(value: 'mk', label: 'Makkah'),
  ];

  DgaDropdownInput<String> _field({
    DgaTextInputStyle style = DgaTextInputStyle.standard,
    DgaTextInputSize size = DgaTextInputSize.large,
    String? label = 'City',
    String? helperText,
    String? errorText,
    bool enabled = true,
  }) => DgaDropdownInput<String>(
    label: label,
    hintText: 'Choose a city',
    helperText: helperText,
    errorText: errorText,
    style: style,
    size: size,
    enabled: enabled,
    value: _city,
    items: _cities,
    onChanged: (v) => setState(() => _city = v),
  );

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaDropdownInput',
    children: [
      sectionHeader(context, 'Live — tap to open the menu'),
      sectionRow(
        SizedBox(width: 320, child: _field(helperText: 'Pick your city.')),
      ),
      sectionHeader(context, 'Styles'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(width: 240, child: _field(label: 'Standard')),
            SizedBox(
              width: 240,
              child: _field(
                label: 'Filled darker',
                style: DgaTextInputStyle.filledDarker,
              ),
            ),
            SizedBox(
              width: 240,
              child: _field(
                label: 'Filled lighter',
                style: DgaTextInputStyle.filledLighter,
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Sizes & states'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 240,
              child: _field(label: 'Medium', size: DgaTextInputSize.medium),
            ),
            SizedBox(
              width: 240,
              child: _field(label: 'Error', errorText: 'Please select a city'),
            ),
            SizedBox(
              width: 240,
              child: _field(label: 'Disabled', enabled: false),
            ),
          ],
        ),
      ),
    ],
  );
}
