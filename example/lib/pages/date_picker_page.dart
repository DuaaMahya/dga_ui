import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime? _date;
  DgaDateRange? _range;
  DateTime? _styled;

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaDatePickerInput',
    children: [
      sectionHeader(context, 'Single — tap to open, or type DD/MM/YYYY'),
      sectionRow(
        SizedBox(
          width: 320,
          child: DgaDatePickerInput.single(
            label: 'Date',
            helperText: 'The field stays typeable while the calendar is open.',
            value: _date,
            onChanged: (d) => setState(() => _date = d),
          ),
        ),
      ),

      sectionHeader(context, 'Range'),
      sectionRow(
        SizedBox(
          width: 320,
          child: DgaDatePickerInput.range(
            label: 'Period',
            value: _range,
            onChanged: (r) => setState(() => _range = r),
          ),
        ),
      ),

      sectionHeader(context, 'Styles'),
      sectionRow(
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Standard',
                value: _styled,
                onChanged: (d) => setState(() => _styled = d),
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Filled darker',
                style: DgaTextInputStyle.filledDarker,
                value: _styled,
                onChanged: (d) => setState(() => _styled = d),
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Filled lighter',
                style: DgaTextInputStyle.filledLighter,
                value: _styled,
                onChanged: (d) => setState(() => _styled = d),
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
              child: DgaDatePickerInput.single(
                label: 'Medium',
                size: DgaTextInputSize.medium,
                value: null,
                onChanged: (_) {},
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Required',
                required: true,
                value: null,
                onChanged: (_) {},
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Error',
                errorText: 'Please pick a date',
                value: null,
                onChanged: (_) {},
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Read-only',
                readOnly: true,
                value: DateTime(2024, 1, 19),
                onChanged: (_) {},
              ),
            ),
            SizedBox(
              width: 240,
              child: DgaDatePickerInput.single(
                label: 'Disabled',
                enabled: false,
                value: null,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),

      sectionHeader(context, 'Bounded to 2024'),
      sectionRow(
        SizedBox(
          width: 320,
          child: DgaDatePickerInput.single(
            label: 'Within 2024 only',
            firstDate: DateTime(2024, 1, 1),
            lastDate: DateTime(2024, 12, 31),
            value: null,
            onChanged: (_) {},
          ),
        ),
      ),

      // Deliberately last: proves the popover flips above the field when
      // there's no room below it.
      sectionHeader(context, 'Near the bottom — popover flips above'),
      sectionRow(
        SizedBox(
          width: 320,
          child: DgaDatePickerInput.single(
            label: 'Bottom of the page',
            value: null,
            onChanged: (_) {},
          ),
        ),
      ),
    ],
  );
}
