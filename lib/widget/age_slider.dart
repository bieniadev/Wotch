import 'package:flutter/material.dart';

class AgeSlider extends StatefulWidget {
  const AgeSlider({super.key});

  @override
  State<AgeSlider> createState() => _AgeSliderState();
}

RangeValues _currentRangeValues = const RangeValues(18, 35);

class _AgeSliderState extends State<AgeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Wiek pracownika', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text('${_currentRangeValues.start.round()}-${_currentRangeValues.end.round()}', style: const TextStyle(fontSize: 18)),
        RangeSlider(
          values: _currentRangeValues,
          min: 18,
          max: 50,
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
      ],
    );
  }
}
