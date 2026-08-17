import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class TextareaPage extends StatelessWidget {
  const TextareaPage({super.key});

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaTextarea',
    children: [
      sectionHeader(
        context,
        'Live — focus to watch the underline grow from center',
      ),
      sectionRow(
        const SizedBox(
          width: 360,
          child: DgaTextarea(
            label: 'Message',
            required: true,
            hintText: 'Write your message…',
            helperText: 'Up to 6 lines before it scrolls.',
          ),
        ),
      ),
      sectionHeader(context, 'Styles'),
      sectionRow(
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 240,
              child: DgaTextarea(label: 'Standard', hintText: 'Standard'),
            ),
            SizedBox(
              width: 240,
              child: DgaTextarea(
                label: 'Filled darker',
                hintText: 'Darker',
                style: DgaTextInputStyle.filledDarker,
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaTextarea(
                label: 'Filled lighter',
                hintText: 'Lighter',
                style: DgaTextInputStyle.filledLighter,
              ),
            ),
          ],
        ),
      ),
      sectionHeader(context, 'States'),
      sectionRow(
        const Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 240,
              child: DgaTextarea(
                label: 'Error',
                errorText: 'This field is required',
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaTextarea(
                label: 'Read-only',
                readOnly: true,
                hintText: 'Read only',
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaTextarea(
                label: 'Disabled',
                enabled: false,
                hintText: 'Disabled',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
