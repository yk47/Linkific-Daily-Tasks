import 'package:flutter/material.dart';

class ImageFitControls extends StatelessWidget {
  const ImageFitControls({
    super.key,
    required this.selectedBoxFit,
    required this.previewWidth,
    required this.onBoxFitChanged,
    required this.onPreviewWidthChanged,
  });

  final BoxFit selectedBoxFit;
  final double previewWidth;
  final ValueChanged<BoxFit> onBoxFitChanged;
  final ValueChanged<double> onPreviewWidthChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BoxFit.values
              .map(
                (BoxFit fit) => ChoiceChip(
                  label: Text(fit.name),
                  selected: selectedBoxFit == fit,
                  onSelected: (_) => onBoxFitChanged(fit),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Text('Preview width: ${previewWidth.toStringAsFixed(0)} px'),
        Slider(
          value: previewWidth,
          min: 160,
          max: 340,
          divisions: 9,
          label: previewWidth.toStringAsFixed(0),
          onChanged: onPreviewWidthChanged,
        ),
      ],
    );
  }
}
