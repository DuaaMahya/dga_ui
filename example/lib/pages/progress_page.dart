import 'package:dga_ui/dga_ui.dart';
import 'package:flutter/material.dart';

import '_gallery_scaffold.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double _v = 0.4;

  @override
  Widget build(BuildContext context) => GalleryScaffold(
    title: 'Progress & Steppers',
    children: [
      sectionHeader(context, 'Linear — drag the slider'),
      sectionRow(
        Column(
          children: [
            Slider(value: _v, onChanged: (v) => setState(() => _v = v)),
            DgaProgressBar(
              value: _v,
              showLabel: true,
              size: DgaProgressBarSize.large,
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Linear — sizes & states'),
      sectionRow(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DgaProgressBar(value: 0.3, size: DgaProgressBarSize.small),
            const SizedBox(height: 12),
            const DgaProgressBar(
              value: 0.6,
              size: DgaProgressBarSize.medium,
              style: DgaProgressBarStyle.neutral,
            ),
            const SizedBox(height: 12),
            const DgaProgressBar(
              value: 1.0,
              success: true,
              size: DgaProgressBarSize.large,
            ),
            const SizedBox(height: 12),
            const DgaProgressBar(
              value: 0.15,
              error: true,
              size: DgaProgressBarSize.large,
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Circular progress'),
      sectionRow(
        Wrap(
          spacing: 24,
          runSpacing: 24,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DgaCircularProgressBar(value: _v, size: 64),
            DgaCircularProgressBar(
              value: _v,
              size: 80,
              style: DgaCircularProgressStyle.neutral,
            ),
            DgaCircularProgressBar(
              value: _v,
              size: 120,
              style: DgaCircularProgressStyle.success,
            ),
            DgaCircularProgressBar(
              value: _v,
              size: 120,
              style: DgaCircularProgressStyle.error,
            ),
          ],
        ),
      ),
      sectionHeader(context, 'Circle stepper'),
      sectionRow(
        const Wrap(
          spacing: 24,
          runSpacing: 24,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DgaCircleStepper(current: 1, total: 4, size: 48),
            DgaCircleStepper(current: 2, total: 4, size: 64),
            DgaCircleStepper(current: 3, total: 4, size: 80),
            DgaCircleStepper(current: 4, total: 4, size: 120),
          ],
        ),
      ),
      sectionHeader(context, 'Radial stepper'),
      sectionRow(
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DgaRadialStepper(
              current: 1,
              total: 3,
              title: 'Account setup',
              size: 56,
            ),
            SizedBox(height: 16),
            DgaRadialStepper(current: 3, total: 3, title: 'All done', size: 56),
          ],
        ),
      ),
    ],
  );
}
