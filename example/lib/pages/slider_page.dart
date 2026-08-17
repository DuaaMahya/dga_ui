import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _val = 20;
  RangeValues _rangeVal = const RangeValues(20, 75);

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'DgaSlider',
    children: [
      sectionHeader(context, 'Slider'),
      sectionRow(
        DgaSlider(value: _val, onChanged: (val) => setState(() => _val = val)),
      ),
      sectionHeader(context, 'Slider with label and helper text'),
      sectionRow(
        DgaSlider(
          label: "Label",
          helpText: "helper text",
          showValueText: true,
          value: _val,
          onChanged: (val) => setState(() => _val = val),
        ),
      ),

      sectionHeader(context, 'Slider Range'),
      sectionRow(
        DgaSlider.range(
          rangeValues: _rangeVal,
          onRangeChanged: (val) => setState(() => _rangeVal = val),
        ),
      ),
      sectionHeader(context, 'Slider with label and helper text'),
      sectionRow(
        DgaSlider.range(
          label: "Label",
          helpText: "helper text",
          min: 0,
          max: 100,
          showMinText: true,
          showMaxText: true,
          rangeValues: _rangeVal,
          onRangeChanged: (val) => setState(() => _rangeVal = val),
        ),
      ),
    ],
  );
}
