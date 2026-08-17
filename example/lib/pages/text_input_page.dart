import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class TextInputPage extends StatelessWidget {
  const TextInputPage({super.key});

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaTextInput',
    children: [
      sectionHeader(
        context,
        'Live — focus to watch the underline grow from center',
      ),
      sectionRow(
        const SizedBox(
          width: 320,
          child: DgaTextInput(
            label: 'Title',
            required: true,
            hintText: 'Type here…',
            helperText: 'The underline animates from the middle outward.',
          ),
        ),
      ),
      sectionHeader(context, 'Sizes'),
      sectionRow(
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'Large',
                hintText: 'Large field',
                size: DgaTextInputSize.large,
              ),
            ),
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'Medium',
                hintText: 'Medium field',
                size: DgaTextInputSize.medium,
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Styles'),
      sectionRow(
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Standard',
                hintText: 'White + border',
                style: DgaTextInputStyle.standard,
              ),
            ),
            SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Filled darker',
                hintText: 'Darker fill',
                style: DgaTextInputStyle.filledDarker,
              ),
            ),
            SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Filled lighter',
                hintText: 'Lighter fill',
                style: DgaTextInputStyle.filledLighter,
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'States'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            const SizedBox(
              width: 220,
              child: DgaTextInput(label: 'Default', hintText: 'Empty'),
            ),
            SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Filled',
                controller: TextEditingController(text: 'Entered text'),
              ),
            ),
            const SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Error',
                controller: null,
                errorText: 'This field is required',
              ),
            ),
            const SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Read-only',
                readOnly: true,
                hintText: 'Read only',
              ),
            ),
            const SizedBox(
              width: 220,
              child: DgaTextInput(
                label: 'Disabled',
                enabled: false,
                hintText: 'Disabled',
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'With icon / prefix / suffix'),
      sectionRow(
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'Search',
                hintText: 'Search…',
                leadingIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'Amount',
                hintText: '0.00',
                prefix: Text('SAR'),
              ),
            ),
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'Website',
                hintText: 'mysite',
                suffix: Text('.gov.sa'),
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Clearable — "×" appears once there\'s text'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'Search',
                hintText: 'Type to see the clear button…',
                leadingIcon: const Icon(Icons.search),
                clearable: true,
                controller: TextEditingController(text: 'Filter query'),
              ),
            ),
            SizedBox(
              width: 260,
              child: DgaTextInput(
                label: 'With suffix',
                hintText: 'Clear button sits before the suffix',
                clearable: true,
                suffix: const Text('.gov.sa'),
                controller: TextEditingController(text: 'mysite'),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
