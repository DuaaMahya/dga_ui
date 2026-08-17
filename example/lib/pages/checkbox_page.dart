import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  bool _a = true;
  bool _b = false;
  final _items = {'One': true, 'Two': false, 'Three': false};

  bool? get _parent {
    final all = _items.values.every((v) => v);
    final none = _items.values.every((v) => !v);
    return all ? true : (none ? false : null);
  }

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaCheckbox',
    children: [
      sectionHeader(context, 'Sizes & styles'),
      sectionRow(
        Wrap(
          spacing: 24,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final s in DgaCheckboxSize.values)
              DgaCheckbox(
                value: _a,
                size: s,
                onChanged: (v) => setState(() => _a = v),
              ),
            DgaCheckbox(
              value: _b,
              style: DgaCheckboxStyle.neutral,
              onChanged: (v) => setState(() => _b = v),
            ),
            const DgaCheckbox(value: true, onChanged: null, disabled: true),
            const DgaCheckbox(
              value: false,
              indeterminate: true,
              onChanged: null,
              disabled: true,
            ),
          ],
        ),
      ),
      sectionHeader(context, 'With label + description'),
      sectionRow(
        SizedBox(
          width: 360,
          child: DgaCheckbox(
            value: _a,
            onChanged: (v) => setState(() => _a = v),
            label: 'Email updates',
            description: 'Get notified about product news and releases.',
          ),
        ),
      ),
      sectionHeader(context, 'Indeterminate parent / children'),
      sectionRow(
        SizedBox(
          width: 360,
          child: Column(
            children: [
              DgaCheckbox(
                value: _parent ?? false,
                indeterminate: _parent == null,
                label: 'Select all',
                onChanged: (v) => setState(() {
                  for (final k in _items.keys) {
                    _items[k] = v;
                  }
                }),
              ),
              const SizedBox(height: 8),
              for (final k in _items.keys)
                Padding(
                  padding: const EdgeInsets.only(left: 32, bottom: 8),
                  child: DgaCheckbox(
                    value: _items[k]!,
                    label: k,
                    onChanged: (v) => setState(() => _items[k] = v),
                  ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}
